//
//  WaitingPlayerViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-24.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit
import Firebase

class WaitingPlayerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startButton: UIButton!

    fileprivate var waitingPlayerViewModel: WaitingPlayerViewModel!
    var gameID: String?
    var admin: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial setting
        startButton.isEnabled = false
        
        waitingPlayerViewModel = WaitingPlayerViewModel()
        waitingPlayerViewModel.waitingPlayerDelegate = self
        
        guard let gameID = gameID else { return }
        waitingPlayerViewModel.gameID = gameID
        
        waitingPlayerViewModel.observeGameInfo()
        
        // TODO: error handling for players
        if admin == false {
            waitingPlayerViewModel.observeRemoveGame()
        }
        
    }
    
    func controlStartButton(){
        let countPlayers = waitingPlayerViewModel.playerList.count
        var cntAnswer = 0
        var cntJoin = 0
        
        for player in waitingPlayerViewModel.playerList {
            if player.status != "Waiting" {
                cntAnswer += 1
                
                if player.status == "Joined" {
                    cntJoin += 1
                }
                
                if countPlayers == cntAnswer, cntJoin >= 1 {
                    startButton.isEnabled = true
                }
            }
        }
    }

    @IBAction func pressedCancell(_ sender: Any) {
        waitingPlayerViewModel.deleteGame()
    }
    @IBAction func pressedStart(_ sender: Any) {
        waitingPlayerViewModel.createPassData()
        self.performSegue(withIdentifier: "showMakeTeam", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMakeTeam" {
            if let makeTeamViewController = segue.destination as? MakeTeamViewController {
                makeTeamViewController.passedData = waitingPlayerViewModel.playerList
            }
        }
        
    }
}

// MARK: UITableViewDelegate
extension WaitingPlayerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waitingPlayerViewModel.playerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WaitingPlayerTableCell", for: indexPath) as! WaitingPlayerTableViewCell
        let values = waitingPlayerViewModel.playerList[indexPath.row]
        cell.setCellValues(cellValues: values)
        return cell
    }
}

extension WaitingPlayerViewController: WaitingPlayerDelegate {
    func didfetchData() {
        self.tableView.reloadData()
        self.controlStartButton()
    }
}