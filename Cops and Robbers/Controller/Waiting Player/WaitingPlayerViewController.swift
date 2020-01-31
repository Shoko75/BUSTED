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
    }

}

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
        print("didfetchData")
    }
    
    func didCreatePassData() {
        self.tableView.reloadData()
    }
    
}
