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
    
    fileprivate var waitingPlayerViewModel: WaitingPlayerViewModel!
    var invitationID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        waitingPlayerViewModel = WaitingPlayerViewModel()
        waitingPlayerViewModel.waitingPlayerDelegate = self
        
        guard let invitationID = invitationID else { return }
        waitingPlayerViewModel.invitationID = invitationID
        
        waitingPlayerViewModel.observeInvitation()
        waitingPlayerViewModel.observeUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func pressedDecline(_ sender: Any) {
        print("pressedDecline")
        
        waitingPlayerViewModel.stopObserve()
        waitingPlayerViewModel.declineInvitation()
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func pressedJoin(_ sender: Any) {
        print("pressedJoin")
        waitingPlayerViewModel.joinInvitation()
        declineButton.isEnabled = false
        joinButton.isEnabled = false
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
        let values = waitingPlayerViewModel.playerList[indexPath.row]
        cell.setCellValues(cellValues: values)
        return cell
    }
}

// MARK: WaitingPlayerDelegate
extension WaitingPlayerViewController: WaitingPlayerDelegate {
    func didStartGame() {
        print("didStartGame")
        self.performSegue(withIdentifier: "showLoadGame", sender: nil)
    }
    
    func didCancleInvitation() {
        let alertController = UIAlertController(title: "Invitation was cancelled", message: "This invitation was canncelled by the owner", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(handler) in
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
