//
//  Logout.swift
//  swift-cognito-boilerplate
//
//  Created by Vic-L on 8/6/18.
//  Copyright © 2018 Vic-L. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

func Logout() {
    let user = GetCurrentUser()
    user?.getSession().continueWith(block: { (task) -> Any? in
        if (task.error != nil) {
            print("Error: " + task.error!.localizedDescription)
        }
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.ACCESS_TOKEN)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.ID_TOKEN)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.REFRESH_TOKEN)
        
        user?.signOut()
        
        // getSession will trigger AppDelegate.startPasswordAuthentication
        user?.getSession().continueOnSuccessWith { (task) -> Any? in
            guard task.error == nil else {
                print("Error: " + task.error!.localizedDescription)
                return nil
            }
            
            UserDefaults.standard.set(task.result!.idToken!.tokenString, forKey: UserDefaultsKeys.ID_TOKEN)
            UserDefaults.standard.set(task.result!.accessToken!.tokenString, forKey: UserDefaultsKeys.ACCESS_TOKEN)
            // TODO implement refresh token
            //                    UserDefaults.standard.set(task.result!.refreshToken!.tokenString, forKey: UserDefaultsKeys.REFRESH_TOKEN)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            ShowAlertView(title: "", message: "User is now signed in. Implement what happens next", okAction: okAction)
            return nil
        }
        
        return nil
    })
}
