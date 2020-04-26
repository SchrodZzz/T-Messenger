//
//  Utils.swift
//  T Messenger
//
//  Created by Suspect on 26.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

final class PresentationUtils {
    class func getCurrentViewController() -> UIViewController? {
        if let navigationController = getNavigationController() {
            return navigationController.visibleViewController
        }
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while currentController.presentedViewController != nil {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }

    private class func getNavigationController() -> UINavigationController? {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController {
            return navigationController as? UINavigationController
        }
        return nil
    }
}
