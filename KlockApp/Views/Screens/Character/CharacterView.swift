//
//  CharacterView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI

struct CharacterView: View {
    @EnvironmentObject var viewModel: CharacterViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Image("character_level_\(viewModel.level)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 240)
                
                Text("불꽃날개 펭귄")
                    .font(.title)
                    .padding()

                Text("레벨: \(viewModel.level)")
                    .font(.headline)
                
                Text("경험치: \(viewModel.experience)")
                    .font(.headline)

                NavigationLink(destination: AchievementsView(characterViewModel: viewModel)) {
                    Text("업적 목록")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

struct AchievementsView: View {
    @ObservedObject var characterViewModel: CharacterViewModel
    
    var body: some View {
        VStack {
            Text("업적 목록")
                .font(.largeTitle)
                .padding(.bottom)
            
            List(characterViewModel.achievements) { achievement in
                HStack {
                    Image(achievement.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading) {
                        Text(achievement.title)
                            .font(.headline)
                        Text(achievement.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

struct CharacterView_Previews: PreviewProvider {
    
    static var previews: some View {
        CharacterView()
    }
}
