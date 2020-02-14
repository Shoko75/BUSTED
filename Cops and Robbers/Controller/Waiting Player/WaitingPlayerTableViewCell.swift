//
//  WaitingPlayerTableViewCell.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-30.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class WaitingPlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    var cellValues: Player!
    
    func setCellValues(cellValues: Player){
        self.cellValues = cellValues
        userNameLabel.text = cellValues.user?.userName
        statusLabel.text = cellValues.status
        if cellValues.status == "Joined" {
            statusLabel.textColor = UIColor.link
        }
        userImageView.contentMode = .scaleToFill
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
        if let userImageURL = cellValues.user?.userImageURL {
            userImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
        }
    }

}
