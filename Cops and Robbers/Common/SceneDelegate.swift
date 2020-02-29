//
//  SceneDelegate.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-10.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        print("scene was called")
        if Auth.auth().currentUser == nil {
                let loginController = R.storyboard.login.instantiateInitialViewController()
                self.window?.rootViewController = loginController
        } else {
            let navigationController = R.storyboard.navigationController.instantiateInitialViewController()
            self.window?.rootViewController = navigationController
        }
    }
}

