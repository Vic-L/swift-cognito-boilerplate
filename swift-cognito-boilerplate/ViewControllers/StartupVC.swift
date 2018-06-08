//
//  StartupVC.swift
//  swift-cognito-boilerplate
//
//  Created by Vic-L on 7/6/18.
//  Copyright © 2018 Vic-L. All rights reserved.
//

import UIKit

class StartupVC: UIViewController {
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("load master data here")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GetCurrentUser()?.getSession() // will trigger AppDelegate.startPasswordAuthentication()
            .continueOnSuccessWith { (task) -> AnyObject? in
                UserDefaults.standard.set(task.result!.idToken!.tokenString, forKey: UserDefaultsKeys.ID_TOKEN)
                UserDefaults.standard.set(task.result!.accessToken!.tokenString, forKey: UserDefaultsKeys.ACCESS_TOKEN)
                // TODO implement refresh token
                //                UserDefaults.standard.set(task.result!.refreshToken!.tokenString, forKey: UserDefaultsKeys.REFRESH_TOKEN)
                
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                ShowAlertView(title: "", message: "User is now signed in. Implement what happens next", okAction: okAction)
                
                //** usually get masterdata at this step
//                firstly { () -> Promise<JSON> in
//                    CallApi here
//                    }.done { resp in
//                        // go to main page
//                    }.catch { error in
//                        ShowErrorResponseMessage(error)
//                }
                
                return nil
        }
    }
}
