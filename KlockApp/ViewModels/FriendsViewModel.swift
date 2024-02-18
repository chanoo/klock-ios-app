//
//  FriendsViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI
import Combine
import Foast

class FriendsViewModel: NSObject, ObservableObject {
    @Published var newMessage: String = ""
    @Published var isPresented = false
    @Published var friendAddViewModel = FriendAddViewModel()
    @Published var isPreparingResponse: Bool = false
    @Published var isLoading: Bool = false
    @Published var friends: [FriendRelationFetchResDTO] = []
    @Published var groupedUserTraces: [UserTraceGroup] = []

    private let friendRelationService = Container.shared.resolve(FriendRelationServiceProtocol.self)
    private let userTraceService = Container.shared.resolve(UserTraceRemoteServiceProtocol.self)

    var cancellables: Set<AnyCancellable> = []
    
    var page = 0
    var userModel = UserModel.load()
    
    func fetchFriends() {
        guard !isLoading else { return } // 이미 로딩 중이라면 중복 호출 방지
        isLoading = true

        friendRelationService.fetch()
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    print("Error fetching study sessions: \(error)")
                case .finished:
                    break
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            } receiveValue: { [weak self] dto in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.friends = dto
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchUserTrace() {
        guard !isLoading else { return } // 이미 로딩 중이라면 중복 호출 방지
        isLoading = true
        
        print("### page", page)

        userTraceService.fetch(page: page, size: 10)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    print("Error fetching user traces: \(error)")
                case .finished:
                    break
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            } receiveValue: { [weak self] dto in
                guard let self = self else { return }
                if !dto.isEmpty {
                    self.page += 1 // 다음 페이지를 위해 page 증가
                }
                let newGrouped = Dictionary(grouping: dto) { (element: UserTraceResDTO) -> String in
                    return element.createdAt.toDateFormat() ?? ""
                }
                
                DispatchQueue.main.async {
                    for (newDate, newUserTraces) in newGrouped {
                        if let index = self.groupedUserTraces.firstIndex(where: { $0.date == newDate }) {
                            // 기존 그룹에 새로운 사용자 트레이스 추가
                            self.groupedUserTraces[index].userTraces.append(contentsOf: newUserTraces)
                        } else {
                            // 새로운 그룹 생성 및 추가
                            let newGroup = UserTraceGroup(date: newDate, userTraces: newUserTraces)
                            self.groupedUserTraces.append(newGroup)
                        }
                    }
                    // 날짜별로 정렬, 필요에 따라 순서를 조정
                    self.groupedUserTraces.sort { $0.date > $1.date }
                }
            }
            .store(in: &cancellables)
    }

    func showActionSheet() {
        self.isPresented = true
    }
        
    func showAddFriendView(for item: SheetType) -> some View {
        switch item {
        case .qrcode:
            return AnyView(FriendAddByQRCodeView().environmentObject(friendAddViewModel))
        case .nickname:
            return AnyView(FriendAddByNicknameView().environmentObject(friendAddViewModel))
        case .nearby:
            return AnyView(FriendAddByNearView().environmentObject(friendAddViewModel))
        case .none:
            return AnyView(EmptyView())
        }
    }
    
    func addUserTrace(contents: String?, image: Data?) {
        let contentTrace = UserTraceCreateReqContentTraceDTO(writeUserId: 128, type: .activity, contents: contents)
        let createReqDTO = UserTraceCreateReqDTO(contentTrace: contentTrace, image: image)

        userTraceService.create(data: createReqDTO)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Error creating user trace: \(error)")
                case .finished:
                    break
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
                        self.groupedUserTraces[index].userTraces.append(dto)
                        self.groupedUserTraces[index].userTraces.sort { $0.id > $1.id }
                    } else {
                        // 새로운 그룹 생성 및 추가
                        let newGroup = UserTraceGroup(date: newDate, userTraces: [dto])
                        self.groupedUserTraces.append(newGroup)
                        // 날짜별로 정렬
                        self.groupedUserTraces.sort { $0.date > $1.date }
                    }
                }
            })
            .store(in: &cancellables)
    }

    func friendAddActionSheet() -> ActionSheet {
        ActionSheet(
            title: Text("친구 추가 방식을 선택하세요"),
            message: Text("어떤 방식으로 친구를 추가하시겠습니까?"),
            buttons: [
                .default(Text("QR코드 스캔"), action: {
                    self.friendAddViewModel.activeSheet = .qrcode
                }),
                .default(Text("닉네임 친구추가"), action: {
                    self.friendAddViewModel.activeSheet = .nickname
                }),
//                .default(Text("주변탐색 친구추가"), action: {
//                    self.friendAddViewModel.activeSheet = .nearby
//                }),
                .cancel()
            ]
        )
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
