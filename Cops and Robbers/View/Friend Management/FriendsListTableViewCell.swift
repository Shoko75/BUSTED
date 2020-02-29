//
//  FriendsListTableViewCell.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-10.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

protocol FriendsListCellDelegate {
    func didPressAccept(indexPath: IndexPath)
}

class FriendsListTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!

    var friendsListCellDelegate: FriendsListCellDelegate?
    var indexPath: IndexPath?
    
    // Button Functions
    @IBAction func pressedAcceptButton(_ sender: Any) {
        friendsListCellDelegate?.didPressAccept(indexPath: indexPath!)
    }
}
