//
//  FriendsListViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 3/7/24.
//

import SwiftUI
import Combine
import Alamofire

class FriendsListViewModel: ObservableObject {
    @Published var friends: [FriendRelationFetchResDTO] = []
    @Published var isLoading: Bool = true

    private let friendRelationService = Container.shared.resolve(FriendRelationServiceProtocol.self)
    private let queue = DispatchQueue(label: "app.klockApp.friendsListViewModelQueue")

    var cancellables: Set<AnyCancellable> = []
    var userModel = UserModel.load()
    
    init() {
        print("FriendsListViewModel init")
    }
    
    func fetchFriends() {
        queue.async { [weak self] in
            guard let self = self else { return }
            friendRelationService.fetch()
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching study sessions: \(error)")
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] dto in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.friends = dto
                    }
                }
                .store(in: &cancellables)
        }
    }
}
