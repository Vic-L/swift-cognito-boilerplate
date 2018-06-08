//
//  ShowAlertView.swift
//  swift-cognito-boilerplate
//
//  Created by Vic-L on 8/6/18.
//  Copyright © 2018 Vic-L. All rights reserved.
//

import UIKit

func ShowAlertView(title: String, message:  String, okAction: UIAlertAction) {
    DispatchQueue.main.async {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alertController.addAction(okAction)
        
        GetTopVC()?.present(alertController, animated: true, completion: nil)
    }
}

func ShowAlertView(title: String, message:  String, okAction: UIAlertAction, cancelAction: UIAlertAction) {
    DispatchQueue.main.async {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        GetTopVC()?.present(alertController, animated: true, completion: nil)
    }
}
