//
//  HomeView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/02.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .background(FancyColor.background.color.edgesIgnoringSafeArea(.all))
        .modifier(CommonViewModifier(title: "홈"))
        .navigationBarItems(leading: BackButtonView())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
