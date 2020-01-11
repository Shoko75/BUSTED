//
//  InviteFriendsTableViewCell.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-10.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class InviteFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var inviteButton: UIButton!
       
    let SECTION_REQUESTING = "Requesting"
    
    var cellValues: Friend!
    fileprivate var invitefriendsViewModel = InviteFriendsViewModel()
    
    func setCellValues(cellValues: Friend, sectionName: String){
        self.invitefriendsViewModel.toCellInviteFriendsDelegate = self
        self.cellValues = cellValues
        userNameLabel.text = cellValues.userName
        userImageView.contentMode = .scaleToFill
        
        if let userImageURL = cellValues.userImageURL {
            userImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
        }
        
        if SECTION_REQUESTING == sectionName {
            inviteButton.isHidden = true
        }
    }
    
    @IBAction func pressedInvite(_ sender: Any) {
        invitefriendsViewModel.sendFrinedRequest(friend: cellValues)
    }
    

}

extension InviteFriendsTableViewCell: ToCellInviteFriendsDelegate {
    func didSendFriendRequest() {
        inviteButton.isEnabled = false
        inviteButton.setTitle("Requesting", for: .normal)
    }
}
