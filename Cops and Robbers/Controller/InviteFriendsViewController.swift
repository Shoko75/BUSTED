//
//  FriendsListViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-01.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class InviteFriendsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var invitefriendsViewModel: InviteFriendsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        invitefriendsViewModel = InviteFriendsViewModel()
        invitefriendsViewModel.inviteFriendsDelegate = self
        invitefriendsViewModel.observeUserInfo()
        
    }
}

extension InviteFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitefriendsViewModel.friendsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteFriendsCell", for: indexPath) as! InviteFriendsTableViewCell
        if let friend = invitefriendsViewModel.friendsList {
            cell.setCellValues(cellValues: friend[indexPath.row])
        }
        
        return cell
    }
}

// MARK: InviteFriendsDelegate
extension InviteFriendsViewController: InviteFriendsDelegate {
    func didFinishObserveUserInfo() {
        self.tableView.reloadData()
    }
}
