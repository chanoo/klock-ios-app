//
//  SignUpTagsViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/03.
//

import Foundation
import Combine
import FacebookLogin
import AuthenticationServices
import Swinject

class SignUpTagsViewModel: NSObject, ObservableObject {
    @Published var nickname: String = ""
    @Published var selectedTags: Set<String> = []
    @Published var showStudyTagsView = false
    @Published var tags: [String] = []

    private let tagService: TagServiceProtocol
    var cancellables: Set<AnyCancellable> = []
    
    let comfirmButtonTapped = PassthroughSubject<Void, Never>()

    init(tagService: TagServiceProtocol = Container.shared.resolve(TagServiceProtocol.self)!) {
        self.tagService = tagService
        super.init()
        setupBindings()
        fetchTags()
    }

    private func setupBindings() {
        setupConfirmButtonTapped()
    }
    
    private func fetchTags() {
        tagService.tags()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching tags: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { tags in
                self.tags = tags.map { $0.name }
            }
            .store(in: &cancellables)
    }

    
    private func setupConfirmButtonTapped() {

    }

}
