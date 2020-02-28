//
//  WaitingPlayerViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-30.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class WaitingPlayerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var customView: CustomUIView!
    
    private var waitingPlayerViewModel = WaitingPlayerViewModel()
    var invitationID: String?
    
    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()

        // Layout setting
        joinButton.layer.cornerRadius = 12
        declineButton.layer.cornerRadius = 12
        
        // Delegate
        waitingPlayerViewModel.waitingPlayerDelegate = self
        
        guard let invitationID = invitationID else { return }
        waitingPlayerViewModel.invitationID = invitationID
        
        // Start observe
        waitingPlayerViewModel.observeInvitation()
        waitingPlayerViewModel.observeUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        customView.roundCorners(cornerRadius: 50.0)
    }
    
    // MARK: Button Functions
    @IBAction func pressedDecline(_ sender: Any) {
        print("pressedDecline")
        
        waitingPlayerViewModel.stopObserveUserInfo()
        waitingPlayerViewModel.stopObserveInvitation()
        waitingPlayerViewModel.declineInvitation()
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func pressedJoin(_ sender: Any) {
        print("pressedJoin")
        
        // Update invitation status as "joined"
        waitingPlayerViewModel.joinInvitation()
        
        // Button setting
        declineButton.isEnabled = false
        declineButton.backgroundColor = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 0.60)
        declineButton.setTitleColor(UIColor.lightGray, for: .normal)
        joinButton.isEnabled = false
        joinButton.backgroundColor = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 0.60)
        joinButton.setTitleColor(UIColor.lightGray, for: .normal)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLoadGame" {
            if let loadGameViewController = segue.destination as? LoadGameViewController {
                loadGameViewController.gameID = invitationID
            }
        }
    }
}

// TableViewDelegate
extension WaitingPlayerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waitingPlayerViewModel.playerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WaitingPlayerTableViewCell", for: indexPath) as! WaitingPlayerTableViewCell
        let player = waitingPlayerViewModel.playerList[indexPath.row]
        
        cell.userNameLabel.text = player.user?.userName
        cell.statusLabel.text = player.status.rawValue
        switch player.status {
        case .Joined:
            cell.statusLabel.textColor = UIColor.link
        default:
            cell.statusLabel.textColor = UIColor.lightGray
        }
            
        cell.userImageView.contentMode = .scaleToFill
        cell.userImageView.layer.masksToBounds = true
        cell.userImageView.layer.cornerRadius = cell.userImageView.bounds.width / 2
        if let userImageURL = player.user?.userImageURL {
            cell.userImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
        }
        return cell
    }
}

// MARK: WaitingPlayerDelegate
extension WaitingPlayerViewController: WaitingPlayerDelegate {
    
    func didStartGame() {
        print("didStartGame")
        
        waitingPlayerViewModel.stopObserveUserInfo()
        self.performSegue(withIdentifier: "showLoadGame", sender: nil)
    }
    
    func didCancleInvitation() {
        print("didCancleInvitation")
        
        let alertController = UIAlertController(title: "Invitation was cancelled",
                                                message: "This invitation was cancelled by the owner",
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .cancel,
                                                handler: {(handler) in
                                                            self.navigationController?.popToRootViewController(animated: false)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func didfetchData() {
        print("didfetchData")
        self.tableView.reloadData()
    }
    
    func didCreatePassData() {
        print("didCreatePassData")
    }
}
