//
//  NotificationMethods.swift
//  T Messenger
//
//  Created by Suspect on 22.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

final class NotificationMethods {

    let viewController: UIViewController!

    init(for viewController: UIViewController) {
        self.viewController = viewController
    }

    #warning("TODO: fix first type bug")
    func keyboardWillChange(_ notification: Notification) {
        guard let keyboardGlobalFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardLocalFrame = viewController.view.convert(keyboardGlobalFrame, from: nil)
        let keyboardInset = max(0, viewController.view.bounds.height - keyboardLocalFrame.minY - viewController.view.safeAreaInsets.bottom + 10)
        viewController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardInset, right: 0)

        let duration: TimeInterval = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let curve = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? 0
        let options = UIView.AnimationOptions(rawValue: curve << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.viewController.view.layoutIfNeeded()
        }, completion: nil)
    }
}
