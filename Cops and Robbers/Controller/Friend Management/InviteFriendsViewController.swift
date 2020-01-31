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
        invitefriendsViewModel.fetchFriendReqFromUserMyself()
        
    }
}

extension InviteFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitefriendsViewModel.friendsList[section].friends.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return invitefriendsViewModel.friendsList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return invitefriendsViewModel.friendsList[section].sectionName
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteFriendsCell", for: indexPath) as! InviteFriendsTableViewCell
        
        let friend = invitefriendsViewModel.friendsList[indexPath.section].friends[indexPath.row]
        let sectionName = invitefriendsViewModel.friendsList[indexPath.section].sectionName
        cell.setCellValues(cellValues: friend, sectionName: sectionName)

        return cell
    }
}

// MARK: InviteFriendsDelegate
extension InviteFriendsViewController: InviteFriendsDelegate {
    func didFinishObserveUserInfo() {
        self.tableView.reloadData()
    }
}
