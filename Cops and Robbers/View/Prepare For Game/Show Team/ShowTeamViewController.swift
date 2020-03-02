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
    @IBOutlet weak var customLeftView: CustomUIView!
    @IBOutlet weak var customRightView: CustomUIView!
    
    private var showTeamViewModle = ShowTeamViewModle()
    
    var gameID: String?
    
    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegate
        showTeamViewModle.showTeamDelegate = self
        showTeamViewModle.fetchGame(gameID: gameID!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        customLeftView.roundLeftCorners(cornerRadius: 50.0)
        customRightView.roundRightCorners(cornerRadius: 50.0)
    }

    // MARK: Segue Setting
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.showTeamViewController.showMap.identifier {
            if let mapViewController = segue.destination as? MapViewController {
                mapViewController.gameData = showTeamViewModle.gameData
                mapViewController.flgCops = showTeamViewModle.flgCops
                mapViewController.gameID = self.gameID
            }
        }
    }
}

// MARK: UITableViewDelegate
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.showTeamTableViewCell, for: indexPath)!
        
        if (showTeamViewModle.cops?.players.count)! - 1 >= indexPath.row {
            cell.setCupsValues(cop: (showTeamViewModle.cops?.players[indexPath.row])!)
        }
        
        if (showTeamViewModle.robbers?.robPlayers.count)! - 1 >= indexPath.row {
            cell.setrobbersValues(robber: (showTeamViewModle.robbers?.robPlayers[indexPath.row])!)
        }
        
        return cell
    }
}

// MARK: ShowTeamDelegate
extension ShowTeamViewController: ShowTeamDelegate {
    func didFetchGame() {
        self.tableView.reloadData()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            self.performSegue(withIdentifier: R.segue.showTeamViewController.showMap, sender: nil)
        }
    }
}
