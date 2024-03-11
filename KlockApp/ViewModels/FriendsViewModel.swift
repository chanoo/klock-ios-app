//
//  FriendsViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI
import Combine
import Foast
import Alamofire

class FriendsViewModel: ObservableObject {
    @Published var dynamicHeight: CGFloat = 36 // 높이 초기값
    @Published var contents: String? = nil
    @Published var image: Data? = nil
    @Published var newMessage: String = ""
    @Published var isSendMessage: Bool = false
    @Published var isPreparingResponse: Bool = false

    @Published var isLoading: Bool = true
    @Published var groupedUserTraces: [UserTraceGroup] = []
    @Published var flogOnIssue: String? = nil
    @Published var followTitle: String = "팔로잉"

    @Published var userId: Int64
    @Published var nickname: String
    @Published var following: Bool

    private let friendRelationService = Container.shared.resolve(FriendRelationServiceProtocol.self)
    private let userTraceService = Container.shared.resolve(UserTraceRemoteServiceProtocol.self)

    let sendTapped = PassthroughSubject<Void, Never>()
    let addHeartTraceTapped = PassthroughSubject<Int64, Never>()
    private let heartTapPublisher = PassthroughSubject<Int64, Never>()
    let deleteUserTraceTapped = PassthroughSubject<Int64, Never>() // 삭제할 사용자 추적 데이터의 ID를 전달하는 Subject
    let unfollowButtonTapped = PassthroughSubject<Bool, Never>()

    private var heartTapCounter: Int = 0
    private var cancellables: Set<AnyCancellable> = []
    private var last = false
    private var page = 0
    
    var userModel = UserModel.load()
    
    private let userTraceFetchQueue = DispatchQueue(label: "app.klockApp.userTraceFetchQueue")

    init(nickname: String, userId: Int64, following: Bool) {
        print("init FriendsViewModel")
        self.nickname = nickname
        self.userId = userId
        self.following = following
        setupSendButtonTapped()
        setupDeleteUserTrace()
        setupAddHeartUserTrace()
        setupUnfollowButtonTapped()
    }
    
    deinit {
        print("deinit FriendsViewModel")
    }
    
    private func setupUnfollowButtonTapped() {
        unfollowButtonTapped
            .sink { [weak self] following in
                guard let self = self else { return }
                
                // 팔로우 상태에 따라 서비스 호출 결정
                let serviceCall: AnyPublisher<Void, AFError>
                if following {
                    serviceCall = self.friendRelationService.follow(followId: userId)
                        .map { _ in Void() } // FriendRelationFollowResDTO를 Void로 변환
                        .eraseToAnyPublisher()
                } else {
                    serviceCall = self.friendRelationService.unfollow(followId: userId)
                        .eraseToAnyPublisher()
                }
                
                serviceCall
                    .sink(receiveCompletion: { result in
                        switch result {
                        case .failure(let error):
                            print("Error processing user relation: \(error)")
                        case .finished:
                            break
                        }
                    }, receiveValue: { [weak self] _ in
                        DispatchQueue.main.async {
                            // 팔로우 상태 업데이트 및 UI 반영
                            self?.updateFollowState(isFollowing: following)
                        }
                    })
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }

    private func updateFollowState(isFollowing: Bool) {
        followTitle = isFollowing ? "팔로잉" : "팔로우"
        following = isFollowing
    }
    
    private func setupSendButtonTapped() {
        sendTapped
            .sink { [weak self] _ in
                guard let userId = self?.userId else { return }
                DispatchQueue.main.async {
                    self?.isSendMessage = true
                    self?.dynamicHeight = 36
                }
                self?.addUserTrace(userId: userId, contents: self?.contents, image: self?.image)
            }
            .store(in: &cancellables)
    }
    
    private func setupAddHeartUserTrace() {
        heartTapPublisher
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] id in
                guard let self = self else { return }
                
                // 탭된 갯수만큼 heartCount를 업데이트하여 서버에 전송
                let heartCountToSend = self.heartTapCounter

                self.userTraceService.addHeart(id: id, heartCount: heartCountToSend)
                    .sink(receiveCompletion: { result in
                        switch result {
                        case .failure(let error):
                            print("Error adding heart: \(error)")
                        case .finished:
                            break
                        }
                    }, receiveValue: { [weak self] response in
                        // 성공적으로 heartCount를 업데이트한 후에 카운터를 초기화
                        self?.groupedUserTraces.forEach { group in
                            if let index = group.userTraces.firstIndex(where: { $0.id == id }) {
                                group.userTraces[index].heartCount = response.heartCount
                            }
                        }
                        self?.heartTapCounter = 0
                    })
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
        
        // 탭 이벤트를 수신하여 카운터를 증가시킵니다.
        addHeartTraceTapped
            .sink { [weak self] id in
                self?.heartTapCounter += 1
                // heartTapPublisher에 이벤트를 발행하여 debounce 처리를 시작하거나 진행 중인 debounce 대기 시간을 재설정합니다.
                self?.heartTapPublisher.send(id)
            }
            .store(in: &cancellables)
    }
    
    private func setupDeleteUserTrace() {
        deleteUserTraceTapped
            .sink { [weak self] id in
                guard let self = self else { return }

                // 서버에서 사용자 추적 데이터 삭제
                self.userTraceService.delete(id: id)
                    .sink(receiveCompletion: { result in
                        switch result {
                        case .failure(let error):
                            print("Error deleting user trace: \(error)")
                        case .finished:
                            break
                        }
                    }, receiveValue: { [weak self] _ in
                        // 로컬에서 사용자 추적 데이터 삭제
                        DispatchQueue.main.async {
                            guard let self = self else { return }
                            for (groupIndex, group) in self.groupedUserTraces.enumerated().reversed() {
                                if let traceIndex = group.userTraces.firstIndex(where: { $0.id == id }) {
                                    self.groupedUserTraces[groupIndex].userTraces.remove(at: traceIndex)
                                    
                                    // 그룹이 비어있으면 그룹 자체를 삭제
                                    if self.groupedUserTraces[groupIndex].userTraces.isEmpty {
                                        self.groupedUserTraces.remove(at: groupIndex)
                                    }
                                    
                                    break
                                }
                            }
                        }
                    })
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
    
    func fetchUserTrace(userId: Int64) {
        userTraceFetchQueue.async { [weak self] in
            guard let self = self, !self.last else { return }
            self.userTraceService.fetch(userId: userId, page: self.page, size: 10)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching user traces: \(error)")
                    case .finished:
                        self.page += 1
                        break
                    }
                } receiveValue: { userTraceDtos in
                    if userTraceDtos.isEmpty {
                        self.last = true
                    }
                    let userTraces = userTraceDtos.map { dto in
                        UserTraceModel.from(dto: dto)
                    }
                                        
                    let newGrouped = Dictionary(grouping: userTraces) { (element: UserTraceModel) -> String in
                        return element.createdAt.toDateFormat() ?? ""
                    }
                    
                    DispatchQueue.main.async {
                        for (newDate, newUserTraces) in newGrouped {
                            if let index = self.groupedUserTraces.firstIndex(where: { $0.date == newDate }) {
                                self.groupedUserTraces[index].userTraces.insert(contentsOf: newUserTraces, at: 0)
                                self.groupedUserTraces[index].userTraces.sort { $0.id > $1.id }
                            } else {
                                let newGroup = UserTraceGroup(date: newDate, userTraces: newUserTraces)
                                self.groupedUserTraces.append(newGroup)
                            }
                        }
                        self.groupedUserTraces.sort { $0.id > $1.id }
                        self.isLoading = false
                    }
                }
                .store(in: &self.cancellables)
        }
    }

    func showAddFriendView(for item: SheetType, viewModel: FriendAddViewModel) -> some View {
        switch item {
        case .qrcode:
            return AnyView(FriendAddByQRCodeView(viewModel: viewModel))
        case .nickname:
            return AnyView(FriendAddByNicknameView(viewModel: viewModel))
        case .nearby:
            return AnyView(FriendAddByNearView(viewModel: viewModel))
        }
    }
    
    func addUserTrace(userId: Int64, contents: String?, image: Data?) {
        userTraceFetchQueue.async { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isSendMessage = true
            }

            guard let writeUserId = userModel?.id else  {
                return
            }
            
            let contentTrace = UserTraceCreateReqContentTraceDTO(userId: userId, writeUserId: writeUserId, type: .activity, contents: contents)
            let createReqDTO = UserTraceCreateReqDTO(contentTrace: contentTrace, image: image)

            userTraceService.create(data: createReqDTO)
                .sink(receiveCompletion: { result in
                    switch result {
                    case .failure(let error):
                        print("Error creating user trace: \(error)")
                    case .finished:
                        break
                    }
                    DispatchQueue.main.async {
                        self.isSendMessage = false
                    }
                }, receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    let model = UserTraceModel.from(dto: response)
                    let endIndex = model.createdAt.index(model.createdAt.startIndex, offsetBy: 19)
                    let dateString = String(model.createdAt[..<endIndex])
                    model.createdAt = dateString
                    
                    let newDate = model.createdAt.toDateFormat()
                    guard let newDate = newDate else { return }

                    DispatchQueue.main.async {
                        if let index = self.groupedUserTraces.firstIndex(where: { $0.date == newDate }) {
                            // 기존 그룹에 결과 추가
                            self.groupedUserTraces[index].userTraces.insert(model, at: 0)
//                            self.groupedUserTraces[index].userTraces.sort { $0.id < $1.id }
                        } else {
                            // 새로운 그룹 생성 및 추가
                            let newGroup = UserTraceGroup(date: newDate, userTraces: [model])
                            self.groupedUserTraces.append(newGroup)
                            // 날짜별로 정렬
                            self.groupedUserTraces.sort { $0.id > $1.id }
                        }
                    }
                })
                .store(in: &cancellables)
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
