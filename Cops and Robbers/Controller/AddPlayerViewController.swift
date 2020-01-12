//
//  AddPlayersViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-12.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class AddPlayerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var addPlayerViewModel: AddPlayerViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addPlayerViewModel = AddPlayerViewModel()
        addPlayerViewModel.addPlayerDelegate = self
        addPlayerViewModel.fetchFriends()
        
    }

}

extension AddPlayerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addPlayerViewModel.playerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddPlayersCell", for: indexPath) as! AddPlayerTableViewCell
        let player = addPlayerViewModel.playerList[indexPath.row]
        cell.setCellValues(cellValues: player)
        return cell
    }
}

extension AddPlayerViewController: AddPlayerDelegate {
    func didFinishFetchData() {
        self.tableView.reloadData()
    }
}
