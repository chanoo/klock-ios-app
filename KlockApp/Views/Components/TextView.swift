//
//  TextView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/09.
//

import SwiftUI
import UIKit

struct TextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var dynamicHeight: CGFloat
    let maxHeight: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0) // 추가된 코드
        textView.text = text
        return textView
    }


    func updateUIView(_ uiView: UITextView, context: Context) {
        DispatchQueue.main.async {
            dynamicHeight = min(uiView.contentSize.height, maxHeight)
        }
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView

        init(_ parent: TextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
            self.parent.dynamicHeight = min(textView.contentSize.height, parent.maxHeight)
        }
    }
}
