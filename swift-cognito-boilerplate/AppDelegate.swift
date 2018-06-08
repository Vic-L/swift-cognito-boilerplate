//
//  AppDelegate.swift
//  swift-cognito-boilerplate
//
//  Created by Vic-L on 7/6/18.
//  Copyright © 2018 Vic-L. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import UserNotifications
import IQKeyboardManagerSwift
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var pool: AWSCognitoIdentityUserPool!
    var loginVC: LoginVC!
    var forceChangePasswordVC: ForceChangePasswordVC!
    var rememberDeviceCompletionSource: AWSTaskCompletionSource<NSNumber>?
    var credentialsProvider: AWSCognitoCredentialsProvider!
    var awsConfiguration: AWSServiceConfiguration!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        
        SVProgressHUD.setDefaultMaskType(.black)
        
        // MARK: Logging AWS
        AWSDDLog.sharedInstance.logLevel = .verbose
        
        // setup service configuration
        let serviceConfiguration = AWSServiceConfiguration(region: COGNITO_IDENTITY_USER_POOL_REGION, credentialsProvider: nil)
        
        // create pool configuration
        let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(
            clientId: COGNITO_IDENTITY_USER_POOL_APP_CLIENT_ID,
            clientSecret: COGNITO_IDENTITY_USER_POOL_APP_CLIENT_SECRET,
            poolId: COGNITO_IDENTITY_USER_POOL_ID)
        
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: poolConfiguration, forKey: COGNITO_USER_POOL_SIGN_IN_PROVIDER_KEY)
        self.pool = AWSCognitoIdentityUserPool(forKey: COGNITO_USER_POOL_SIGN_IN_PROVIDER_KEY)
        self.pool.delegate = self
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
        self.loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        
        self.forceChangePasswordVC = storyboard.instantiateViewController(withIdentifier: "ForceChangePasswordVC") as! ForceChangePasswordVC

        
        // request notification permission
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
    }
}

extension AppDelegate: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                UIApplication.shared.keyWindow?.rootViewController = self.loginVC
            }, completion: nil)
        }
        return self.loginVC
    }
    
    //    func startMultiFactorAuthentication() -> AWSCognitoIdentityMultiFactorAuthentication {
    //        if (self.mfaViewController == nil) {
    //            self.mfaViewController = MFAViewController()
    //            self.mfaViewController?.modalPresentationStyle = .popover
    //        }
    //        DispatchQueue.main.async {
    //            if (!self.mfaViewController!.isViewLoaded
    //                || self.mfaViewController!.view.window == nil) {
    //                //display mfa as popover on current view controller
    //                let viewController = self.window?.rootViewController!
    //                viewController?.present(self.mfaViewController!,
    //                                        animated: true,
    //                                        completion: nil)
    //
    //                // configure popover vc
    //                let presentationController = self.mfaViewController!.popoverPresentationController
    //                presentationController?.permittedArrowDirections = UIPopoverArrowDirection.left
    //                presentationController?.sourceView = viewController!.view
    //                presentationController?.sourceRect = viewController!.view.bounds
    //            }
    //        }
    //        return self.mfaViewController!
    //    }
    
    func startRememberDevice() -> AWSCognitoIdentityRememberDevice {
        return self
    }
    
    func startNewPasswordRequired() -> AWSCognitoIdentityNewPasswordRequired {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                UIApplication.shared.keyWindow?.rootViewController = self.forceChangePasswordVC
            }, completion: nil)
        }
        return self.forceChangePasswordVC
    }
}

extension AppDelegate: AWSCognitoIdentityRememberDevice {
    // TODO check and tetwhat this feature does
    func getRememberDevice(_ rememberDeviceCompletionSource: AWSTaskCompletionSource<NSNumber>) {
        self.rememberDeviceCompletionSource = rememberDeviceCompletionSource
        DispatchQueue.main.async {
            // dismiss the view controller being present before asking to remember device
            self.window?.rootViewController!.presentedViewController?.dismiss(animated: true, completion: nil)
            let alertController = UIAlertController(title: "Remember Device",
                                                    message: "Do you want to remember this device?.",
                                                    preferredStyle: .actionSheet)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                self.rememberDeviceCompletionSource?.set(result: true)
            })
            let noAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
                self.rememberDeviceCompletionSource?.set(result: false)
            })
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func didCompleteStepWithError(_ _error: Error?) {
        guard let error = _error as NSError? else {
            return
        }
        
        ShowAlertView(title: error.userInfo["__type"] as! String, message: error.userInfo["message"] as! String, okAction: UIAlertAction(title: "Retry", style: .default, handler: nil))
    }
}
