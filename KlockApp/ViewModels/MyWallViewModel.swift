//
//  MyWallViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 3/7/24.
//

import SwiftUI
import Combine
import Foast
import Alamofire

class MyWallViewModel: ObservableObject {
    @Published var isPreparingResponse: Bool = false
    @Published var isLoading: Bool = true
    @Published var isSendMessage: Bool = false
    @Published var groupedUserTraces: [UserTraceGroup] = []
    @Published var dynamicHeight: CGFloat = 36 // 높이 초기값
    @Published var contents: String = ""
    @Published var image: Data? = nil
    @Published var flogOnIssue: String? = nil
    @Published var isNavigatingToFriendView: Bool = false
    @Published var isNavigatingToFriendListView: Bool = false

    var nickname: String?
    var userId: Int64?
    var following: Bool = false

    private let friendRelationService = Container.shared.resolve(FriendRelationServiceProtocol.self)
    private let userTraceService = Container.shared.resolve(UserTraceRemoteServiceProtocol.self)

    let sendTapped = PassthroughSubject<Void, Never>()
    let deleteUserTraceTapped = PassthroughSubject<Int64, Never>() // 삭제할 사용자 추적 데이터의 ID를 전달하는 Subject
    let unfollowButtonTapped = PassthroughSubject<Bool, Never>()

    var cancellables: Set<AnyCancellable> = []
    var last = false
    var page = 0
    
    var userModel = UserModel.load()
    
    private let userTraceFetchQueue = DispatchQueue(label: "app.klockApp.userTraceFetchQueue")

    init() {
        print("init MyWallViewModel")
        setupSendButtonTapped()
        setupDeleteUserTrace()
        setupNotification() 
    }
    
    deinit {
        print("deinit MyWallViewModel")
    }
    
    private func setupNotification() {
        NotificationCenter.default.publisher(for: .nextToFriendViewNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] notification in
                print("call nextToFriendViewNotification")
                if let userInfo = notification.userInfo,
                   let nickname = userInfo["nickname"] as? String,
                   let userId = userInfo["userId"] as? Int64 {
                    print("nickname: \(nickname), userId: \(userId)")
                    self?.nickname = nickname
                    self?.userId = userId
                    self?.isNavigatingToFriendView = true
                }
            }
            .store(in: &cancellables)
    }
        
    private func setupSendButtonTapped() {
        sendTapped
            .sink { [weak self] _ in
                guard let userId = self?.userModel?.id else { return }
                DispatchQueue.main.async {
                    self?.isSendMessage = true
                    self?.dynamicHeight = 36
                }
                self?.addUserTrace(userId: userId, contents: self?.contents, image: self?.image)
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
                } receiveValue: { dto in
                    if dto.isEmpty {
                        self.last = true
                    }
                    let newGrouped = Dictionary(grouping: dto) { (element: UserTraceResDTO) -> String in
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
                    var dto = response
                    let endIndex = dto.createdAt.index(dto.createdAt.startIndex, offsetBy: 19)
                    let dateString = String(dto.createdAt[..<endIndex])
                    dto.createdAt = dateString
                    
                    let newDate = dto.createdAt.toDateFormat()
                    guard let newDate = newDate else { return }

                    DispatchQueue.main.async {
                        if let index = self.groupedUserTraces.firstIndex(where: { $0.date == newDate }) {
                            // 기존 그룹에 결과 추가
                            self.groupedUserTraces[index].userTraces.insert(dto, at: 0)
//                            self.groupedUserTraces[index].userTraces.sort { $0.id < $1.id }
                        } else {
                            // 새로운 그룹 생성 및 추가
                            let newGroup = UserTraceGroup(date: newDate, userTraces: [dto])
                            self.groupedUserTraces.append(newGroup)
                            // 날짜별로 정렬
                            self.groupedUserTraces.sort { $0.id > $1.id }
                        }
                    }
                })
                .store(in: &cancellables)
        }
    }
    
    func viewDidAppear() {
        isNavigatingToFriendView = false
        isNavigatingToFriendListView = false
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Notification.Name {
    static let nextToFriendViewNotification = Notification.Name("nextToFriendViewNotification")
}
