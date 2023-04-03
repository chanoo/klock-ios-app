//
//  StudyTagsView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/03.
//

import SwiftUI

struct SignUpTagsView: View {
    @Binding var selectedTags: Set<String>
    @State private var tags: [String] = [] // 서버에서 가져온 태그 목록을 여기에 저장하세요.

    var onNext: () -> Void

    var body: some View {
        VStack {
            Text("공부 중인 분야를 선택하세요")
                .font(.largeTitle)
                .padding()

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(tags, id: \.self) { tag in
                    Button(action: {
                        if selectedTags.contains(tag) {
                            selectedTags.remove(tag)
                        } else {
                            selectedTags.insert(tag)
                        }
                    }, label: {
                        Text(tag)
                            .foregroundColor(selectedTags.contains(tag) ? .white : .black)
                            .padding()
                            .background(selectedTags.contains(tag) ? Color.blue : Color.gray)
                            .cornerRadius(8)
                    })
                }
            }

            Button(action: {
                onNext()
            }, label: {
                Text("완료")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            })
            .padding(.top, 30)
            Spacer()
        }
        .padding()
    }
}

struct SignUpTagsView_Previews: PreviewProvider {
    static var previews: some View {
//        SignUpTagsView()
        EmptyView()
    }
}
