import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        -> Bool {
            window = UIWindow(frame: UIScreen.main.bounds)
            FirebaseApp.configure()
            checkLogined()
            return true
            
    }
    
    func checkLogined() {
        if let uid = UserDefaults.standard.value(forKey: "UID") {
            let viewController = instantiate(ServiceLogin.self)
            guard let uidExport = uid as? String else { return }
            viewController.inject(presenter: ServiceLoginPresenterImp(email: "", pass: "", uid: uidExport))
            print(uidExport)
            viewController.rootUIStoryboard()
            
        } else {
            let viewController = instantiate(Login.self)
            viewController.rootUIStoryboard()
        }
    }
}

