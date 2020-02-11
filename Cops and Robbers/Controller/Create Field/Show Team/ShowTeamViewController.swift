//
//  ShowTeamViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-28.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class ShowTeamViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var gameID: String?
    var showTeamViewModle: ShowTeamViewModle!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showTeamViewModle = ShowTeamViewModle()
        showTeamViewModle.showTeamDelegate = self
        showTeamViewModle.fetchGame(gameID: gameID!)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMap" {
            if let mapViewController = segue.destination as? MapViewController {
                mapViewController.gameData = showTeamViewModle.gameData
                mapViewController.flgCops = showTeamViewModle.flgCops
                mapViewController.gameID = self.gameID
            }
        }
    }
}

extension ShowTeamViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        
        if let copsRow = showTeamViewModle.cops?.players.count,
            let robbersRow = showTeamViewModle.robbers?.robPlayers.count {
            
            if copsRow > robbersRow {
                rows = copsRow
            } else {
                rows = robbersRow
            }
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "showTeamTableViewCell", for: indexPath) as! ShowTeamTableViewCell
        
        if showTeamViewModle.cops?.players.count != 0 {
            cell.setCupsValues(cop: (showTeamViewModle.cops?.players[indexPath.row])!)
        }
        
        if showTeamViewModle.robbers?.robPlayers.count != 0 {
            cell.setrobbersValues(robber: (showTeamViewModle.robbers?.robPlayers[indexPath.row])!)
        }
        
        return cell
        
    }
    
}

extension ShowTeamViewController: ShowTeamDelegate {
    func didFetchGame() {
        self.tableView.reloadData()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            self.performSegue(withIdentifier: "showMap", sender: nil)
        }
    }
}
