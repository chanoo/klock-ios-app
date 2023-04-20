//
//  ToastView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/20.
//

import SwiftUI

struct ToastMessageView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.black)
            .padding(20)
            .background(BlurView(style: .systemUltraThinMaterialLight))
            .cornerRadius(40)
    }
}

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct ToastView: UIViewRepresentable {
    let message: String

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        let hostingController = UIHostingController(rootView: ToastMessageView(message: message))
        hostingController.view.backgroundColor = .clear
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
