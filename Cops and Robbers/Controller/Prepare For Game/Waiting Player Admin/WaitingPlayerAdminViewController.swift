//
//  WaitingPlayerAdminViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-24.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class WaitingPlayerAdminViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var customView: CustomUIView!
    
    fileprivate var waitingPlayerViewModel = WaitingPlayerViewModel()
    var invitationID: String?
    
    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout setting
        startButton.layer.cornerRadius = 12
        cancelButton.layer.cornerRadius = 12
        startButton.isEnabled = false
        
        // Delegate
        waitingPlayerViewModel.waitingPlayerDelegate = self
        
        guard let invitationID = invitationID else { return }
        waitingPlayerViewModel.invitationID = invitationID
        
        // Start observeing
        waitingPlayerViewModel.observeInvitation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        customView.roundCorners(cornerRadius: 50.0)
    }

    // MARK: Button Functions
    @IBAction func pressedCancell(_ sender: Any) {
        waitingPlayerViewModel.deleteInvitation()
        self.navigationController?.popToRootViewController(animated: false)
    }
    @IBAction func pressedStart(_ sender: Any) {
        waitingPlayerViewModel.createPassData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showLoadGame" {
            if let loadGameViewController = segue.destination as? LoadGameViewController {
                loadGameViewController.passedData = waitingPlayerViewModel.playerList
                loadGameViewController.flgAdmin = true
                loadGameViewController.gameID = invitationID
            }
        }
    }
    
    // MARK: Others
    // Controll the start button whether enable or not by the player's answer
    func controlStartButton(){
        let countPlayers = waitingPlayerViewModel.playerList.count
        var cntAnswered = 0
        var cntJoined = 0
        
        for player in waitingPlayerViewModel.playerList {
            
            switch player.status {
            case .Waiting: return
            case .Joined:
                cntAnswered += 1
                cntJoined += 1
            case .Declined:
                cntAnswered += 1
            }
            
            // If all players have been answered and have been joined more than one player, set the start button as enable.
            if countPlayers == cntAnswered, cntJoined >= 1 {
                startButton.isEnabled = true
                startButton.backgroundColor = UIColor.systemOrange
                startButton.setTitleColor(UIColor.white, for: .normal)
                waitingPlayerViewModel.stopObserveInvitation()
            }
        }
    }
}

// MARK: UITableViewDelegate
extension WaitingPlayerAdminViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waitingPlayerViewModel.playerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WaitingPlayerAdminTableCell", for: indexPath) as! WaitingPlayerAdminTableViewCell
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
extension WaitingPlayerAdminViewController: WaitingPlayerDelegate {
    func didStartGame() {
        print("didStartGame")
    }
    
    func didCancleInvitation() {
        print("didCancleInvitation")
    }
    
    func didCreatePassData() {
        self.performSegue(withIdentifier: "showLoadGame", sender: nil)
    }
    
    func didfetchData() {
        self.tableView.reloadData()
        self.controlStartButton()
    }
}
