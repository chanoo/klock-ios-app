import SwiftUI
import FacebookCore

@main
struct KlockAppApp: App {
    let persistenceController = PersistenceController.shared
    let container = Container.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SignInView(viewModel: container.resolve(SignInViewModel.self)!)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: UIApplication.shared.applicationState) { state in
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
}
