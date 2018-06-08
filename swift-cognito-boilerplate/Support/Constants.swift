//
//  Constants.swift
//  swift-cognito-boilerplate
//
//  Created by Vic-L on 8/6/18.
//  Copyright © 2018 Vic-L. All rights reserved.
//

import AWSCognitoIdentityProvider

 // TODO think about using env and plist as env variables rather than constants that are going to be committed to cloud
let COGNITO_IDENTITY_USER_POOL_REGION: AWSRegionType = .APSoutheast1
let COGNITO_IDENTITY_USER_POOL_ID = "COGNITO_IDENTITY_USER_POOL_ID"
let COGNITO_IDENTITY_USER_POOL_APP_CLIENT_ID = "COGNITO_IDENTITY_USER_POOL_APP_CLIENT_ID"
let COGNITO_IDENTITY_USER_POOL_APP_CLIENT_SECRET = "COGNITO_IDENTITY_USER_POOL_APP_CLIENT_SECRET"
let COGNITO_FEDERATED_IDENTITY_ID = "COGNITO_FEDERATED_IDENTITY_ID"

let COGNITO_USER_POOL_SIGN_IN_PROVIDER_KEY = "UserPool"

let API_BASE_URL = "something"

struct Alerts {
    static let errorHeader = "Oops!"
}

struct UserDefaultsKeys {
    static let ACCESS_TOKEN: String = "UserDefaultsKeys.ACCESS_TOKEN"
    static let ID_TOKEN: String = "UserDefaultsKeys.ID_TOKEN"
    static let REFRESH_TOKEN: String = "UserDefaultsKeys.REFRESH_TOKEN"
}
