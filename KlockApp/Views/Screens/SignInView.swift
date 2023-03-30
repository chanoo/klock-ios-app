import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: SignInViewModel
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        ScrollView {
            VStack {
                FancyTextField(placeholder: "이메일 주소", text: $viewModel.email, keyboardType: .emailAddress)
                    .padding(.top, 200)

                FancyTextField(placeholder: "비밀번호", text: $viewModel.password, isSecureField: true)
                    .padding(.bottom, 20)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 20)
                }

                FancyButton(title: "로그인", action: {
                    viewModel.signInButtonTapped.send()
                }, backgroundColor: .blue, foregroundColor: .white)
                .padding(.bottom, 20)
                
                // Divider
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.gray)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                
                HStack {
                    FancyButton(title: "페이스북으로 로그인", action: {
                        viewModel.signInWithFacebookTapped.send()
                    }, backgroundColor: .blue, foregroundColor: .white)

                    FancyButton(title: "애플로 로그인", action: {
                        viewModel.signInWithAppleTapped.send()
                    }, backgroundColor: .black, foregroundColor: .white)
                }

            }
            .padding()
        }
    }
}
