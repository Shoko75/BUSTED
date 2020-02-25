//
//  InviteFriendsTableViewCell.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-10.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

protocol InviteFriendsCellDelegate {
    func didPressInvite(indexPath: IndexPath)
}

class InviteFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var inviteButton: UIButton!
    
    var indexPath: IndexPath!
    var inviteFriendsCellDelegate: InviteFriendsCellDelegate?
    
    // MARK: Button Functions
    @IBAction func pressedInvite(_ sender: Any) {
        inviteFriendsCellDelegate?.didPressInvite(indexPath: indexPath)
    }
}
