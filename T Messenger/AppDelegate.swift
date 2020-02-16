//
//  AppDelegate.swift
//  T Messenger
//
//  Created by Suspect on 14.02.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    var window: UIWindow?

    //MARK: Application states
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        printStateInfo(forFunctionNamed: #function)

        return true
    }


    #if PRINT_APP_STATES
        private func printStateInfo(forFunctionNamed functionName: String) {
            print("Application moved from <Not running> to <Foreground, Inactive>: \(functionName)")
        }

        func applicationDidEnterBackground(_ application: UIApplication) {
            print("Application moved from <Foreground, Inactive> to <Background>: \(#function)")
        }

        func applicationWillEnterForeground(_ application: UIApplication) {
            print("Application moved from <Background> to <Foreground, Inactive>: \(#function)")
        }


        func applicationDidBecomeActive(_ application: UIApplication) {
            print("Application moved from <Foreground, Inactive> to <Foreground, Active>: \(#function)")
        }

        func applicationWillResignActive(_ application: UIApplication) {
            print("Application moved from <Foreground, Active> to <Foreground, Inactive>: \(#function)")
        }


        func applicationWillTerminate(_ application: UIApplication) {
            print("Application moved from <Background> to <Not running>: \(#function)")
        }
    #else
        private func printStateInfo() { }
    #endif

}

