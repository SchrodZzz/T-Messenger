//
//  CustomAnimations.swift
//  T Messenger
//
//  Created by Suspect on 26.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

final class CustomAnimations {
    
    class func shake(_ view: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 10, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 10, y: view.center.y))
        view.layer.add(animation, forKey: "position")
    }
    
    class func highlight(_ view: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .curveEaseOut],
        animations: {
            view.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }, completion: { _ in
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
}
