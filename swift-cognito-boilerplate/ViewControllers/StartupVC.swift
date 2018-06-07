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
        self.goToLoginVC()
    }
}
