import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: SignInViewModel
    @Environment(\.managedObjectContext) private var viewContext

    @ViewBuilder
    var destinationView: some View {
        if let destination = viewModel.destination {
            switch destination {
            case .home:
                HomeView() // HomeView를 구현하신 것으로 가정합니다.
            case .signUp:
                SignUpView(viewModel: SignUpViewModel()) // 컨테이너를 사용하지 않고 직접 인스턴스를 생성합니다.
            default:
                EmptyView()
            }
        } else {
            EmptyView()
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {

                        Image("ic_klock")
                            .padding(.top, 130)
                            .padding(.bottom, 32)

                        Text("여기까지 온 당신, 이미 반은 성공!")
                            .foregroundColor(FancyColor.primary.color)
                            .font(.system(size: 16))
                            .padding(.bottom, 4)

                        Text("제대로 성공하러 가볼까요?")
                            .foregroundColor(FancyColor.primary.color)
                            .font(.system(size: 24))
                            .padding(.bottom, 80)

                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.bottom, 20)
                        }

                        FancyButton(title: "페이스북으로 시작하기", action: {
                            viewModel.signInWithFacebookTapped.send()
                        }, backgroundColor: FancyColor.facebook.color, foregroundColor: .white, icon: Image("ic_facebook"))
                        .padding(.bottom, 18)

                        FancyButton(title: "애플로 시작하기", action: {
                            viewModel.signInWithAppleTapped.send()
                        }, backgroundColor: .black, foregroundColor: .white, icon: Image("ic_apple"))

                    }
                    .padding()
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
            }.background(FancyColor.background.color.edgesIgnoringSafeArea(.all))
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
