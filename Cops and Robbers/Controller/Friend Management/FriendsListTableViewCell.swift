//
//  FriendsListTableViewCell.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-10.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class FriendsListTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!

    let SECTION_FRIENDDS = "Friends"
    
    var cellValues: Friend!
    fileprivate var friendsListViewModel = FriendsListViewModel()
    
    func setCellValues(cellValues: Friend, sectionName: String){
        self.friendsListViewModel.toCellFriendsListDelegate = self
        self.cellValues = cellValues
        userNameLabel.text = cellValues.userName
        userImageView.contentMode = .scaleToFill
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
        if let userImageURL = cellValues.userImageURL {
            userImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
        }
        
        if SECTION_FRIENDDS == sectionName {
            acceptButton.isHidden = true
        }
    }
    
    
    @IBAction func pressedAcceptButton(_ sender: Any) {
        friendsListViewModel.registerFriend(friendUID: cellValues.uid)
    }
}

extension FriendsListTableViewCell: ToCellfriendsListDelegate {
    func didRegisterFriend() {
        acceptButton.isEnabled = false
        acceptButton.setTitle("Button_accepted", for: .normal)
    }
}
