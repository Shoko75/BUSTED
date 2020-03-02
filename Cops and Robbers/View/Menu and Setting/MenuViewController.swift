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
    @IBOutlet weak var inviteAlert: UIImageView!
    @IBOutlet weak var friendReqAlert: UIImageView!
    
    var window: UIWindow?
    var menuViewModel: MenuViewModel!
    
    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        menuViewModel = MenuViewModel()
        menuViewModel.menuDelegate = self
        joinFieldButton.isEnabled = menuViewModel.flgJoinField
        inviteAlert.isHidden = !menuViewModel.flgJoinField
        friendReqAlert.isHidden = !menuViewModel.flgFriendReq
        
        setNavBar()
        menuViewModel.checkInvitationStatus()
        menuViewModel.checkFriendReq()
    }
    
    func setNavBar() {
        
        // Right Item
        let userButton = UIButton(type: .system)
        let largeConfig = UIImage.SymbolConfiguration(textStyle: .title1)
        userButton.setImage(UIImage(systemName: "person.crop.circle", withConfiguration: largeConfig)!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: .normal)
        userButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: userButton)
        self.navigationItem.rightBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showUserSetting)))
        
        // Title
        let logo = R.image.logo.navbar()
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        // Delete navigation bar under line
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc func showUserSetting() {
        print("showUserSetting")
        let userSettingVC = R.storyboard.userSetting.instantiateInitialViewController()
        userSettingVC!.modalPresentationStyle = .popover
        self.present(userSettingVC!, animated: true, completion: nil)
    }
    
    // MARK: Button Functions
    @IBAction func pressedCreateField(_ sender: Any) {
        // Add Player
        performSegue(withIdentifier: R.segue.menuViewController.showAddPlayer, sender: nil)
    }
    
    @IBAction func pressedFriendsList(_ sender: Any) {
        // Friends List
        performSegue(withIdentifier: R.segue.menuViewController.showFriendsList, sender: nil)
    }
    
    @IBAction func pressedJoinField(_ sender: Any) {
        // Waiting Player
        performSegue(withIdentifier: R.segue.menuViewController.showWaitingPlayer, sender: nil)
    }
    
    @IBAction func pressedHowToPlay(_ sender: Any) {
        // How To Play
        performSegue(withIdentifier: R.segue.menuViewController.showHowToPlay, sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Waiting Player
        if segue.identifier == R.segue.menuViewController.showWaitingPlayer.identifier {
            if let waitingPlayerViewController = segue.destination as? WaitingPlayerViewController {
                waitingPlayerViewController.invitationID = self.menuViewModel.invitationID
            }
        }
    }
}

// MARK: MenuDelegate
extension MenuViewController: MenuDelegate {
    
    func didFinishCheckFriendReq() {
        friendReqAlert.isHidden = !self.menuViewModel.flgFriendReq
    }
    
    func didFinishCheckInvitationStatus() {
        joinFieldButton.isEnabled = self.menuViewModel.flgJoinField
        inviteAlert.isHidden = !self.menuViewModel.flgJoinField
    }
    
    
}

// MARK: 
extension MenuViewController {
    @objc static let cfNotificationSupport = "CFNotificationSupport"
}
