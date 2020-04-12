//
//  AppDelegate.swift
//  T Messenger
//
//  Created by Suspect on 14.02.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let rootAssembly = RootAssembly()

    var window: UIWindow?

    // MARK: - Application states

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let controller = rootAssembly.presentationAssembly.allChannelsViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

}
