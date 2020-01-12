//
//  AddPlayersTableViewCell.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-12.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class AddPlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addedButton: UIButton!

    var cellValues: Friend!
    fileprivate var addPlayerViewModel = AddPlayerViewModel()
    
    func setCellValues(cellValues: Friend){
        self.cellValues = cellValues
        userNameLabel.text = cellValues.userName
        userImageView.contentMode = .scaleToFill
        
        if let userImageURL = cellValues.userImageURL {
            userImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
        }
    }
}
