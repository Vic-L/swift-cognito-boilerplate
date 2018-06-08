//
//  GetIdToken.swift
//  swift-cognito-boilerplate
//
//  Created by Vic-L on 8/6/18.
//  Copyright © 2018 Vic-L. All rights reserved.
//

import Foundation

func GetIdToken() -> String? {
    return UserDefaults.standard.string(forKey: UserDefaultsKeys.ID_TOKEN)
}
