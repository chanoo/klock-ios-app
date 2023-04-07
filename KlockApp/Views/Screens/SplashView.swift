//
//  SplashView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/08.
//

import SwiftUI

struct SplashView: View {
    @StateObject var viewModel: SplashViewModel
    
    @ViewBuilder
    var destinationView: some View {
        HomeView()
    }
    
    var body: some View {
        ZStack {
            FancyColor.primary.color.edgesIgnoringSafeArea(.all)

            VStack {
                Image("ic_klock_3dot")
                    .padding(.bottom, 32)
                
                Text("남과의 경쟁이 아닌")
                    .font(.system(size: 22))
                    .foregroundColor(Color.white)
                    .padding(.bottom, 2)

                Text("나의 성장을 위해")
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
            }
        }
        NavigationLink(
            destination: destinationView,
            isActive: .constant(viewModel.destination != nil),
            label: {
                EmptyView()
            }
        )
        .onAppear {
            viewModel.resetDestination()
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(viewModel: SplashViewModel())
    }
}
