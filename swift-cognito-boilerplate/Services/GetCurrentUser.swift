//
//  GetCurrentUser.swift
//  swift-cognito-boilerplate
//
//  Created by Vic-L on 8/6/18.
//  Copyright © 2018 Vic-L. All rights reserved.
//

import AWSCognitoIdentityProvider

func GetCurrentUser() -> AWSCognitoIdentityUser? {
    var currentUser: AWSCognitoIdentityUser?
    
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    
    
    DispatchQueue.global(qos: .default).sync {
        currentUser = (UIApplication.shared.delegate as! AppDelegate).pool.currentUser()
        dispatchGroup.leave()
    }
    
    dispatchGroup.wait()
    
    return currentUser
}
