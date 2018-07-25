//
//  UIViewControllerExtensions.swift
//  swift-cognito-boilerplate
//
//  Created by Vic-L on 7/6/18.
//  Copyright © 2018 Vic-L. All rights reserved.
//

import UIKit

extension UIViewController {
    func goToLoginVC(completion: (((Bool) -> Void)?) = nil) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
            
            UIView.transition(with: window, duration: 0.35, options: .transitionFlipFromLeft, animations: {
                UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavVC") as! UINavigationController
            }, completion: completion)
        }
    }
    
    func goToMainVC(completion: (((Bool) -> Void)?) = nil) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            UIView.transition(with: window, duration: 0.35, options: .transitionFlipFromLeft, animations: {
                UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            }, completion: completion)
        }
    }
}
