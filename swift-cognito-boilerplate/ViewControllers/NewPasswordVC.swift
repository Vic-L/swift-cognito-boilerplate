//
//  NewPasswordVC.swift
//  swift-cognito-boilerplate
//
//  Created by Vic-L on 25/7/18.
//  Copyright © 2018 Vic-L. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider
import SVProgressHUD

class NewPasswordVC: UIViewController {

    // MARK: Variables
    var user: AWSCognitoIdentityUser?
    
    // MARK: IBOutlets
    @IBOutlet weak var txtConfirmationCode: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!

    // MARK: IBActions
    @IBAction func btnUpdatePasswordClicked(_ sender: AnyObject) {
        guard let confirmationCodeValue = self.txtConfirmationCode.text, !confirmationCodeValue.isEmpty else {
            let alertController = UIAlertController(title: "Password Field Empty",
                                                    message: "Please enter a password of your choice.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion:  nil)
            return
        }
        
        SVProgressHUD.show()
        self.user?.confirmForgotPassword(confirmationCodeValue, password: self.txtNewPassword.text!).continueWith {[weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else { return nil }
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()

                if let error = task.error as NSError? {
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    ShowAlertView(title: error.userInfo["__type"] as! String, message: error.userInfo["message"] as! String, okAction: okAction)
                } else {
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                    })
                    // TODO use localization for message
                    ShowAlertView(title: Alerts.successHeader, message: "Successfully updated password", okAction: okAction)
                }
            })
            return nil
        }
    }
    
}

