//
//  MakeTeamViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-28.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class MakeTeamViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var passedData = [Player]()
    var makeTeamViewModle: MakeTeamViewModle!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeTeamViewModle = MakeTeamViewModle()
        makeTeamViewModle.makeTeamDelegate = self
        makeTeamViewModle.createTeam(playersInfo: passedData)
        
    }

}

extension MakeTeamViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        
        if makeTeamViewModle.copsPlayer.count < makeTeamViewModle.robbersPlayer.count {
            rows = makeTeamViewModle.robbersPlayer.count
        } else {
            rows = makeTeamViewModle.copsPlayer.count
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "makeTeamTableViewCell", for: indexPath) as! MakeTeamTableViewCell
        
        if makeTeamViewModle.copsPlayer.count - 1 >= indexPath.row {
            let copPlayer = makeTeamViewModle.copsPlayer[indexPath.row]
            cell.setCupsValues(cop: copPlayer)
        }
        
        if makeTeamViewModle.robbersPlayer.count - 1 >= indexPath.row {
            let robberPlayer = makeTeamViewModle.robbersPlayer[indexPath.row]
            cell.setrobbersValues(robber: robberPlayer)
        }
        
        return cell
        
    }
    
}

extension MakeTeamViewController: MakeTeamDelegate {
    func didFinshCreateTeam() {
        
        self.tableView.performBatchUpdates({
            self.tableView.reloadData()
        }) { (finished) in
            sleep(5)
            self.performSegue(withIdentifier: "showLoadGame", sender: nil)
        }
    }
}
