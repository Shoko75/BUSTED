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
    @IBOutlet weak var customVIew: CustomUIView!
    fileprivate var friendsListViewModel: FriendsListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsListViewModel = FriendsListViewModel()
        friendsListViewModel.friendsListDelegate = self
        friendsListViewModel.fetchFriendReq()
        friendsListViewModel.fetchFriends()
    }
    
    override func viewDidLayoutSubviews() {
        customVIew.roundCorners(cornerRadius: 50.0)
    }
}

extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsListViewModel.friendsList[section].friends.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return friendsListViewModel.friendsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 23/255, green: 23/255, blue: 49/255, alpha: 1)
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = friendsListViewModel.friendsList[section].sectionName
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
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
