//
//  FriendsListViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-10.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class FriendsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customVIew: CustomUIView!
    
    let SECTION_FRIENDDS = "Friends"
    
    private var friendsListViewModel = FriendsListViewModel()
    
    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // viewModel Delegate
        friendsListViewModel.friendsListDelegate = self
        friendsListViewModel.fetchFriendReq()
        friendsListViewModel.fetchFriends()
        
        // emptyDataSet Delegate
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
    }
    
    override func viewDidLayoutSubviews() {
        customVIew.roundCorners(cornerRadius: 50.0)
    }
}

// MARK: UITableViewDelegate
extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsListViewModel.friendsList[section].friends.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if friendsListViewModel.friendsList.count == 0 {
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        } else {
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        }
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.friendsListCell, for: indexPath)!
        let (friend, isAcceptedFlg) = friendsListViewModel.friendsList[indexPath.section].friends[indexPath.row]
        let sectionName = friendsListViewModel.friendsList[indexPath.section].sectionName
       
        cell.indexPath = indexPath
        cell.friendsListCellDelegate = self
        cell.userNameLabel.text = friend.userName
        cell.userImageView.contentMode = .scaleToFill
        cell.userImageView.layer.masksToBounds = true
        cell.userImageView.layer.cornerRadius = cell.userImageView.bounds.width / 2
        if let userImageURL = friend.userImageURL {
            cell.userImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
        }
        
        if SECTION_FRIENDDS == sectionName {
            cell.acceptButton.isHidden = true
        } else {
            cell.acceptButton.isHidden = false
            if isAcceptedFlg {
                cell.acceptButton.isEnabled = false
                cell.acceptButton.setImage(R.image.button.accepted(), for: .normal)
            } else {
                cell.acceptButton.isEnabled = true
                cell.acceptButton.setImage(R.image.button.accept(), for: .normal)
            }
        }
        
        return cell
    }
}

// MARK: FriendsListDelegate
extension FriendsListViewController: FriendsListDelegate {
    
    func didFinishFetchData() {
        self.tableView.reloadData()
    }
}

// MARK: FriendsListCellDelegate
extension FriendsListViewController: FriendsListCellDelegate {
    func didPressAccept(indexPath: IndexPath) {
        friendsListViewModel.friendsList[indexPath.section].friends[indexPath.row].1 = true
        let uid = friendsListViewModel.friendsList[indexPath.section].friends[indexPath.row].0.uid
        friendsListViewModel.registerFriend(friendUID: uid)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

// MARK: DZNEmptyDataSetDelegate
extension FriendsListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "You don't have any friends"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Tap the plus button to add a friend"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}
