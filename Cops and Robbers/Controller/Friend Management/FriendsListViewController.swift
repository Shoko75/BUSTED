//
//  FriendsListViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-10.
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
        friendsListViewModel.fetchFriendReq()
        friendsListViewModel.fetchFriends()
    }
}

extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsListViewModel.friendsList[section].friends.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return friendsListViewModel.friendsList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendsListViewModel.friendsList[section].sectionName
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsListCell", for: indexPath) as! FriendsListTableViewCell
        
        let friend = friendsListViewModel.friendsList[indexPath.section].friends[indexPath.row]
        let sectionName = friendsListViewModel.friendsList[indexPath.section].sectionName
        cell.setCellValues(cellValues: friend, sectionName: sectionName)

        return cell
    }
}

// MARK: FriendsListDelegate
extension FriendsListViewController: FriendsListDelegate {
    
    func didFinishFetchData() {
        self.tableView.reloadData()
    }
}
