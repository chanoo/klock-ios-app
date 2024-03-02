//
//  FlagOnIssueContentView.swift
//  KlockApp
//
//  Created by 성찬우 on 3/2/24.
//

import SwiftUI

struct FlagOnIssueContentView: View {
    @EnvironmentObject var actionSheetManager: ActionSheetManager

    @State var flagOnIssue: String?
    var onIssueSelected: (String) -> Void  // 선택된 이슈를 외부로 전달하기 위한 클로저

    // 문제 유형을 나타내는 배열
    let issueTypes = [
        "부적절한 사진을 보냈어요",
        "욕설을 해요",
        "성희롱을 해요",
        "비매너 사용자에요",
        "불쾌감을 주는 대화를 시도해요",
        "이외에 다른 문제가 있어요"
    ]

    var body: some View {
        VStack{
            ForEach(issueTypes, id: \.self) { issueType in
                FancyButton(
                    title: issueType,
                    disableAction: {
                        self.flagOnIssue = issueType
                        self.onIssueSelected(issueType)  // 사용자가 이슈를 선택하면 클로저를 호출하여 외부로 전달
                    },
                    alignment: .leading,
                    disabled: .constant(flagOnIssue != issueType),
                    style: .constant(.outline)
                )
            }
            
            FancyButton(
                title: "제출하기",
                action: {
                    withAnimation(.spring()) {
                        print("flagOnIssue \(flagOnIssue ?? "nil")")
                        actionSheetManager.isPresented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            actionSheetManager.actionSheet = nil
                        }
                    }
                },
                disabled: .constant(flagOnIssue == nil),
                style: .constant(.black)
            )
            .padding(.top, 20)
        }
    }
}
