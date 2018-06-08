//
//  GetTopVC.swift
//  swift-cognito-boilerplate
//
//  Created by Vic-L on 8/6/18.
//  Copyright © 2018 Vic-L. All rights reserved.
//

import UIKit

func GetTopVC() -> UIViewController? {
    return UIApplication.shared.keyWindow?.visibleViewController
}
