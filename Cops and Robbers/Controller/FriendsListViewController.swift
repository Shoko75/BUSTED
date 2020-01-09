//
//  FriendsListViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-01.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class FriendsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var friendsListViewModel: FriendsListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        friendsListViewModel = FriendsListViewModel()
        friendsListViewModel.friendsListDelegate = self
        friendsListViewModel.observeUserInfo()
        
    }
}

extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsListViewModel.friendsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsListCell", for: indexPath) as! FriendsListCell
        if let friend = friendsListViewModel.friendsList {
            cell.userNameLabel.text = friend[indexPath.row].userName
        } else {
            cell.userNameLabel.text = "Test Name"
        }
        
        return cell
    }
}

// MARK: FriendsListDelegate
extension FriendsListViewController: FriendsListDelegate {
    func didFinishObserveUserInfo() {
        self.tableView.reloadData()
    }
}

// MARK: FriendsListCell
class FriendsListCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
}


