import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: SignInViewModel
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        ScrollView {
            VStack {
                TextField("이메일 주소", text: $viewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .padding(.top, 200)

                SecureField("비밀번호", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .padding(.bottom, 20)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 20)
                }

                Button(action: {
                    viewModel.signInButtonTapped.send()
                }) {
                    Text("로그인")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(5)
                }
                
                // Divider
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.gray)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                
                HStack {
                    Button(action: {
                        viewModel.signInWithFacebookTapped.send()
                    }) {
                        Text("페이스북으로 로그인")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(5)
                    }

                    Button(action: {
                        viewModel.signInWithAppleTapped.send()
                    }) {
                        Text("애플로 로그인")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(5)
                    }
                }


            }
            .padding()
        }
    }
}
