//
//  AppDelegate+GestureRecognizerDelegate.swift
//  T Messenger
//
//  Created by Suspect on 25.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

extension AppDelegate: UIGestureRecognizerDelegate {

    func addGestureRecognizer() {
        let tinkoffLogoShowGesture = UILongPressGestureRecognizer(target: self, action: #selector(showTinkoffLogo))
        tinkoffLogoShowGesture.minimumPressDuration = 0.2
        tinkoffLogoShowGesture.delegate = self
        window?.addGestureRecognizer(tinkoffLogoShowGesture)
    }

    @objc func showTinkoffLogo(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let currentViewController = PresentationUtils.getCurrentViewController()
            let trans = sender.location(in: window)
            AnimatedTinkoffLogos.shared.center = CGPoint(x: trans.x, y: trans.y)
            currentViewController?.view.addSubview(AnimatedTinkoffLogos.shared)
            AnimatedTinkoffLogos.startAnimation()
        } else if sender.state == .changed {
            let trans = sender.location(in: window)
            AnimatedTinkoffLogos.shared.center = CGPoint(x: trans.x, y: trans.y)
        } else if sender.state == .ended {
            AnimatedTinkoffLogos.stopAnimation()
            AnimatedTinkoffLogos.shared.removeFromSuperview()
        }
    }
}

final class AnimatedTinkoffLogos {
    static let shared: UIView = {
        let viewSizeSide = UIScreen.main.bounds.width / 4
        let viewSize = CGSize(width: viewSizeSide, height: viewSizeSide)
        let viewFrame = CGRect(origin: CGPoint(), size: viewSize)
        let view = UIView(frame: viewFrame)
        return view
    }()
    
    private static let maxInternalRadius = UIScreen.main.bounds.width / 6
    
    private static var smallLogoView: UIImageView {
        let viewSizeSide = UIScreen.main.bounds.width / 8
        let viewSize = CGSize(width: viewSizeSide, height: viewSizeSide)
        let point = CGPoint(x: shared.frame.size.width / 4, y: shared.frame.size.height / 4)
        let viewFrame = CGRect(origin: point, size: viewSize)
        let view = UIImageView(frame: viewFrame)
        view.image = UIImage(named: "SmallTinkoffLogo")
        return view
    }
    
    class func startAnimation() {
        for _ in 0 ..< 3 {
            let view = smallLogoView
            shared.addSubview(view)
            animateLogo(view)
        }
    }
    
    class func stopAnimation() {
        for curView in shared.subviews {
            curView.removeFromSuperview()
        }
    }
    
    private class func animateLogo(_ view: UIView) {
        view.alpha = 0.0
        
        UIView.animateKeyframes(withDuration: 2.5, delay: 0, options: [.autoreverse, .repeat], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.5, animations: {
                view.transform = CGAffineTransform(scaleX: 2, y: 2)
                view.alpha = 1.0
                
            })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 3.0, animations: {
                view.center.x += CGFloat.random(in: -maxInternalRadius...maxInternalRadius)
                view.center.y += CGFloat.random(in: -maxInternalRadius...maxInternalRadius)
                view.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: -CGFloat.pi ... CGFloat.pi))
            })
        }, completion: nil)
    }
}
