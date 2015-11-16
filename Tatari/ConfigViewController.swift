//
//  ConfigViewController.swift
//  Tatari
//
//  Created by Déborah Mesquita on 07/11/15.
//  Copyright © 2015 Caio Araújo. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btLogoutPressed(sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }

}
