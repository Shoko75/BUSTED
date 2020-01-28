//
//  WaitingPlayerViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-24.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class WaitingPlayerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startButton: UIButton!

    fileprivate var waitingPlayerViewModel: WaitingPlayerViewModel!
    var gameID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waitingPlayerViewModel = WaitingPlayerViewModel()
        waitingPlayerViewModel.waitingPlayerDelegate = self
        if let gameID = gameID {
            waitingPlayerViewModel.observeGameInfo(gameID: gameID)
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
    }
}
