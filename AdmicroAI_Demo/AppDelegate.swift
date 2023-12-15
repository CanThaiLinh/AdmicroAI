//
//  AppDelegate.swift
//  AdmicroAI_Demo
//
//  Created by Admin on 31/10/2023.
//

import UIKit
import AdmicroAI
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        AdmAI_Manager.shared.register(email: "", password: "")
        AdmAI_Manager.shared.enableDebugLog()
        IQKeyboardManager.shared().isEnabled = true
        AdmAI_Manager.shared.delegate = self
        AdmAI_Manager.shared.start()
        
        let speechVC = SpeechViewController()
        let speechNavi = UINavigationController(rootViewController: speechVC)
        speechNavi.tabBarItem = UITabBarItem(title: "Speech", image: UIImage(systemName: "pencil.circle.fill"), tag: 0)
        
        let orcVC = OcrViewController()
        let orcNavi = UINavigationController(rootViewController: orcVC)
        orcNavi.tabBarItem = UITabBarItem(title: "Orc", image: UIImage(systemName: "globe.asia.australia.fill"), tag: 1)
        
        let faceVC = FaceViewController()
        let facesNavi = UINavigationController(rootViewController: faceVC)
        facesNavi.tabBarItem = UITabBarItem(title: "Face", image: UIImage(systemName: "face.dashed.fill"), tag: 2)
        
        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [speechNavi, orcNavi, facesNavi]
        tabbarController.tabBar.tintColor = UIColor.tintColor()
        tabbarController.tabBar.unselectedItemTintColor = UIColor.untintColor()
                
        tabbarController.tabBar.isTranslucent = false
        tabbarController.tabBar.backgroundColor = UIColor.barColor()
        tabbarController.tabBar.barTintColor = UIColor.barColor()

        window?.overrideUserInterfaceStyle = .light
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
        
        return true
        
    }
}

extension AppDelegate: AdmAI_ManagerDelegate {
    func stateSDK(_ state: Bool) {
        if state {
            print("SDK đã sẵn sàng")
        } else {
            print("SDK chưa sẵn sàng")
        }
    }
    
    
}

