//
//  ForgotPasswordVC.swift
//  swift-cognito-boilerplate
//
//  Created by Vic-L on 25/7/18.
//  Copyright © 2018 Vic-L. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider
import SVProgressHUD

class ForgotPasswordVC: UIViewController {
    
    var pool: AWSCognitoIdentityUserPool?
    var user: AWSCognitoIdentityUser?
    
    @IBOutlet weak var txtUsername: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pool = AWSCognitoIdentityUserPool(forKey: COGNITO_USER_POOL_SIGN_IN_PROVIDER_KEY)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK :- IBActions
    
    // handle forgot password
    @IBAction func btnSubmitClicked(_ sender: AnyObject) {
        guard let username = self.txtUsername.text, !username.isEmpty else {
            
            let alertController = UIAlertController(title: "Missing UserName",
                                                    message: "Please enter a valid user name.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion:  nil)
            return
        }
        
        SVProgressHUD.show()
        self.user = self.pool?.getUser(self.txtUsername.text!)
        self.user?.forgotPassword().continueWith{[weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else {return nil}
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()

                if let error = task.error as NSError? {
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    ShowAlertView(title: error.userInfo["__type"] as! String, message: error.userInfo["message"] as! String, okAction: okAction)
                } else {
                    let storyboard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
                    let newPasswordVC: NewPasswordVC = storyboard.instantiateViewController(withIdentifier: "NewPasswordVC") as! NewPasswordVC
                    newPasswordVC.user = strongSelf.user
                    strongSelf.navigationController?.pushViewController(newPasswordVC, animated: true)
                }
            })
            return nil
        }
    }
}

