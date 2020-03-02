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
    @IBOutlet weak var customView: CustomUIView!
    
    private var invitefriendsViewModel = InviteFriendsViewModel()

    let SECTION_REQUESTING = "Requesting"
    
    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        invitefriendsViewModel.inviteFriendsDelegate = self
        invitefriendsViewModel.fetchFriendReqFromUserMyself()
    }
    
    override func viewDidLayoutSubviews() {
        customView.roundCorners(cornerRadius: 50.0)
    }
}

// MARK: UITableViewDelegate
extension InviteFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitefriendsViewModel.friendsList[section].friends.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return invitefriendsViewModel.friendsList.count
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
        title.text = invitefriendsViewModel.friendsList[section].sectionName
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inviteFriendsCell, for: indexPath)!
        let (friend, isRequestedFlg) = invitefriendsViewModel.friendsList[indexPath.section].friends[indexPath.row]
        let sectionName = invitefriendsViewModel.friendsList[indexPath.section].sectionName

        cell.indexPath = indexPath
        cell.inviteFriendsCellDelegate = self
        cell.userNameLabel.text = friend.userName
        cell.userImageView.contentMode = .scaleToFill
        cell.userImageView.layer.masksToBounds = true
        cell.userImageView.layer.cornerRadius = cell.userImageView.bounds.width / 2
        if let userImageURL = friend.userImageURL {
            cell.userImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
        }
        
        if SECTION_REQUESTING == sectionName {
            cell.inviteButton.isHidden = true
        } else {
            cell.inviteButton.isHidden = false
            if isRequestedFlg {
                cell.inviteButton.isEnabled = false
                cell.inviteButton.setImage(R.image.button.requested(), for: .normal)
            } else {
                cell.inviteButton.isEnabled = true
                cell.inviteButton.setImage(R.image.button.add(), for: .normal)
            }
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

// MARK: InviteFriendsCellDelegate
extension InviteFriendsViewController: InviteFriendsCellDelegate {
    func didPressInvite(indexPath: IndexPath) {
    invitefriendsViewModel.friendsList[indexPath.section].friends[indexPath.row].1 = true
        let (friend, _) = invitefriendsViewModel.friendsList[indexPath.section].friends[indexPath.row]
        invitefriendsViewModel.registerFrinedRequest(friend: friend)
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}
