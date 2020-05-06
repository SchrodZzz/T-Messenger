//
//  CustomAnimations.swift
//  T Messenger
//
//  Created by Suspect on 15.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

final class CustomAnimations {

    static func shakeButton(_ button: UIButton) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: button.center.x - 10, y: button.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: button.center.x + 10, y: button.center.y))
        button.layer.add(animation, forKey: "position")
    }

}
