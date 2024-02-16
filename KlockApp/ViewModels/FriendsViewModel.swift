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
    
    var userModel = UserModel.load()
    
    func fetchFriends() {
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
        isLoading = true

        userTraceService.fetch()
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
                let grouped = Dictionary(grouping: dto) { (element: UserTraceFetchResDTO) -> String in
                    return element.createdAt.toDateFormat() ?? ""
                }
                .map { UserTraceGroup(date: $0.key, userTraces: $0.value) }
                .sorted { $0.date > $1.date }
                DispatchQueue.main.async {
                    self.groupedUserTraces = grouped
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
