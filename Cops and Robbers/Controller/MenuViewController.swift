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
    
    @IBOutlet weak var joinFieldButton: UIButton!
    
    var window: UIWindow?
    var menuViewModel: MenuViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        menuViewModel = MenuViewModel()
        menuViewModel.menuDelegate = self
        joinFieldButton.isEnabled = menuViewModel.flgJoinField
        
        showSignOut()
        menuViewModel.checkInvitationStatus()
        
    }
    
    func showSignOut() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "SignOut", style: .plain, target: self, action: #selector(signOut))
        
        let logo = UIImage(named: "Busted_logo_navbar")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
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
    
    @IBAction func pressedCreateField(_ sender: Any) {
        performSegue(withIdentifier: "showAddPlayer", sender: nil)
    }
    
    @IBAction func pressedFriendsList(_ sender: Any) {
        performSegue(withIdentifier: "showFriendsList", sender: nil)
    }
    
    @IBAction func pressedJoinField(_ sender: Any) {
        performSegue(withIdentifier: "showWaitingPlayer", sender: nil)
    }
    
    @IBAction func pressedHowToPlay(_ sender: Any) {
        performSegue(withIdentifier: "showHowToPlay", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showWaitingPlayer" {
            if let waitingPlayerViewController = segue.destination as? WaitingPlayerViewController {
                waitingPlayerViewController.invitationID = self.menuViewModel.invitationID
            }
        }
    }
}

extension MenuViewController: MenuDelegate {
    func didFinishcheckInvitationStatus() {
        joinFieldButton.isEnabled = self.menuViewModel.flgJoinField
    }
}
