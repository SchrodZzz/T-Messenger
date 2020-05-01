//
//  Notificator.swift
//  T Messenger
//
//  Created by Suspect on 01.05.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

final class Notificator {
    
    enum MessageType: String {
        case error, info
    }
    
    class func notifyUser(_ message: String, type: MessageType, in vc: UIViewController) {
        let alert = UIAlertController(title: type.rawValue.firstUppercased, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        vc.present(alert, animated: true)
    }
}
