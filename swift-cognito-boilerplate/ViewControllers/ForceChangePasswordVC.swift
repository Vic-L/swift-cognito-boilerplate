//
//  ForceChangePasswordVC.swift
//  swift-cognito-boilerplate
//
//  Created by Vic-L on 8/6/18.
//  Copyright © 2018 Vic-L. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import SVProgressHUD

class ForceChangePasswordVC: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var txtPassword: UITextField!
    
    // MARK: Variables
    var newPasswordRequiredCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityNewPasswordRequiredDetails>?
    
    // MARK: IBActions
    @IBAction func btnSubmitClicked(_ sender: Any) {
        if (self.txtPassword.text != nil) {
            let authDetails = AWSCognitoIdentityNewPasswordRequiredDetails(proposedPassword: self.txtPassword.text!)
            self.newPasswordRequiredCompletionSource?.set(result: authDetails)
        } else {
            let alertController = UIAlertController(title: "Missing information",
                                                    message: "Please enter a valid user name and password",
                                                    preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
            alertController.addAction(retryAction)
        }
    }
}

extension ForceChangePasswordVC: AWSCognitoIdentityNewPasswordRequired {
    func getNewPasswordDetails(_ newPasswordRequiredInput: AWSCognitoIdentityNewPasswordRequiredInput, newPasswordRequiredCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityNewPasswordRequiredDetails>) {
        self.newPasswordRequiredCompletionSource = newPasswordRequiredCompletionSource
    }
    
    func didCompleteNewPasswordStepWithError(_ error: Error?) {
        SVProgressHUD.dismiss()

        if let error = error as NSError? {
            let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                    message: error.userInfo["message"] as? String,
                                                    preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
            alertController.addAction(retryAction)
            
            self.present(alertController, animated: true, completion:  nil)
        } else {
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            ShowAlertView(title: "", message: "User is now signed in. Implement what happens next", okAction: okAction)
        }
    }
}
