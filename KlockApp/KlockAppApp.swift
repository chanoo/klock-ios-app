import SwiftUI
import FacebookCore

@main
struct KlockAppApp: App {
    let persistenceController = PersistenceController.shared
    let container = Container.shared

    @StateObject private var appFlowManager = AppFlowManager()
    @StateObject private var signUpUserModel = SignUpUserModel()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: container.resolve(ContentViewModel.self))
                .environmentObject(appFlowManager)
                .environmentObject(signUpUserModel)
        }
        .onChange(of: UIApplication.shared.applicationState) { handleAppStateChange($0) }
    }

    private func handleAppStateChange(_ state: UIApplication.State) {
        switch state {
        case .active:
            // 앱이 활성 상태일 때 수행할 작업을 여기에 작성하세요.
            break
        case .inactive:
            // 앱이 비활성 상태일 때 수행할 작업을 여기에 작성하세요.
            break
        case .background:
            // 앱이 백그라운드 상태일 때 수행할 작업을 여기에 작성하세요.
            break
        @unknown default:
            // 알 수 없는 새로운 상태에 대한 처리를 여기에 작성하세요.
            break
        }
    }
}
