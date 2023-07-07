//
//  UserViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/07/07.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var userModel: UserModel? {
        didSet {
            saveUser()
        }
    }
    
    init() {
        loadUser()
    }
    
    func saveUser() {
        let encoder = JSONEncoder()
        if let userModel = userModel, let encoded = try? encoder.encode(userModel) {
            UserDefaults.standard.set(encoded, forKey: "user")
        }
    }
    
    func loadUser() {
        if let savedUser = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(UserModel.self, from: savedUser) {
                self.userModel = loadedUser
            }
        }
    }
}
