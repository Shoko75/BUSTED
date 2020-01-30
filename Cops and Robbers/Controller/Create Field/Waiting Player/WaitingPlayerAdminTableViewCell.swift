//
//  WaitingPlayerAdminTableViewCell.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-24.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class WaitingPlayerAdminTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    var cellValues: Player!
    
    func setCellValues(cellValues: Player){
        self.cellValues = cellValues
        userNameLabel.text = cellValues.user?.userName
        statusLabel.text = cellValues.status
        userImageView.contentMode = .scaleToFill
        
        if let userImageURL = cellValues.user?.userImageURL {
            userImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
        }
    }
}
