//
//  LoginVC.swift
//  swift-cognito-boilerplate
//
//  Created by Vic-L on 7/6/18.
//  Copyright © 2018 Vic-L. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import SVProgressHUD

class LoginVC: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    // MARK: Variables
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    var rememberDeviceCompletionSource: AWSTaskCompletionSource<NSNumber>?
    
    // MARK: IBActions
    @IBAction func btnLoginClicked(_ sender: Any) {
        SVProgressHUD.show()
        if (self.txtEmail.text != nil && self.txtPassword.text != nil) {
            let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: self.txtEmail.text!, password: self.txtPassword.text! )
            self.passwordAuthenticationCompletion?.set(result: authDetails)
        } else {
            let alertController = UIAlertController(title: "Missing information",
                                                    message: "Please enter a valid user name and password",
                                                    preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
            alertController.addAction(retryAction)
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func btnForgotPasswordClicked(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
        let forgotPasswordVC: ForgotPasswordVC = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
}

extension LoginVC: AWSCognitoIdentityPasswordAuthentication {
    func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource

        // TODO implement last know email
//        guard let lastKnownEmail = authenticationInput.lastKnownUsername else {
//            return
//        }
//
//        DispatchQueue.main.async {
//            self.txtEmail.text = lastKnownEmail
//        }
    }
    
    func didCompleteStepWithError(_ _error: Error?) {
        guard let error = _error as NSError? else {
            return
        }
        
        SVProgressHUD.dismiss()

        ShowAlertView(title: error.userInfo["__type"] as! String, message: error.userInfo["message"] as! String, okAction: UIAlertAction(title: "Retry", style: .default, handler: nil))
    }
}
