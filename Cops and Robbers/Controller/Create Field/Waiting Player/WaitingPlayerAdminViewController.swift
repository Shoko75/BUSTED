//
//  WaitingPlayerAdminViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-24.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit
import Firebase

class WaitingPlayerAdminViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startButton: UIButton!

    fileprivate var waitingPlayerAdminViewModel: WaitingPlayerAdminViewModel!
    var invitationID: String?
    var admin: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial setting
        startButton.isEnabled = false
        
        waitingPlayerAdminViewModel = WaitingPlayerAdminViewModel()
        waitingPlayerAdminViewModel.waitingPlayerAdminDelegate = self
        
        guard let invitationID = invitationID else { return }
        waitingPlayerAdminViewModel.invitationID = invitationID
        
        waitingPlayerAdminViewModel.observeInvitation()
        
    }
    
    func controlStartButton(){
        let countPlayers = waitingPlayerAdminViewModel.playerList.count
        var cntAnswer = 0
        var cntJoin = 0
        
        for player in waitingPlayerAdminViewModel.playerList {
            if player.status != "Waiting" {
                cntAnswer += 1
                
                if player.status == "Joined" {
                    cntJoin += 1
                }
                
                if countPlayers == cntAnswer, cntJoin >= 1 {
                    startButton.isEnabled = true
                    waitingPlayerAdminViewModel.stopObserve()
                }
            }
        }
    }

    @IBAction func pressedCancell(_ sender: Any) {
        waitingPlayerAdminViewModel.deleteInvitation()
        self.navigationController?.popToRootViewController(animated: false)
    }
    @IBAction func pressedStart(_ sender: Any) {
        waitingPlayerAdminViewModel.createPassData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMakeTeam" {
            if let makeTeamViewController = segue.destination as? MakeTeamViewController {
                makeTeamViewController.passedData = waitingPlayerAdminViewModel.playerList
            }
        }
        
    }
}

// MARK: UITableViewDelegate
extension WaitingPlayerAdminViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waitingPlayerAdminViewModel.playerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WaitingPlayerAdminTableCell", for: indexPath) as! WaitingPlayerAdminTableViewCell
        let values = waitingPlayerAdminViewModel.playerList[indexPath.row]
        cell.setCellValues(cellValues: values)
        return cell
    }
}

extension WaitingPlayerAdminViewController: WaitingPlayerAdminDelegate {
    func didCreatePassData() {
        self.performSegue(withIdentifier: "showMakeTeam", sender: nil)
    }
    
    func didfetchData() {
        self.tableView.reloadData()
        self.controlStartButton()
    }
}
