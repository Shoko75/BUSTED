//
//  MenuViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-19.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()

        showSignOut()
    }
    
    func showSignOut() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "SignOut", style: .plain, target: self, action: #selector(signOut))
    }
    
    @objc func signOut() {
        do {
            try Auth.auth().signOut()
            let storybord = UIStoryboard(name: "Login", bundle: nil)
            let loginController = storybord.instantiateViewController(identifier: "Login") as! LoginViewController
            self.view.window?.rootViewController = loginController
            
        } catch let error {
            print("Faild to sign out with error: \(error)")
        }
    }
    
}
