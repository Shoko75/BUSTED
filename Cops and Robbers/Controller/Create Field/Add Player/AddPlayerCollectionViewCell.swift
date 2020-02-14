//
//  AddPlayerCollectionViewCell.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-20.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

protocol AddPlayerCollectionViewCellDelegate {
    func pressedDelete(id: String)
}

class AddPlayerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var cellValues: Friend!
    var addPlayerCollectionViewCellDelegate: AddPlayerCollectionViewCellDelegate?
    
    func setCellValues(cellValues: Friend) {
        self.cellValues = cellValues
        userNameLabel.text = cellValues.userName
        userImageView.contentMode = .scaleToFill
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
        if let userImageURL = cellValues.userImageURL {
            userImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
        }
    }
    
    @IBAction func pressedDeleteButton(_ sender: Any) {
        addPlayerCollectionViewCellDelegate?.pressedDelete(id: cellValues.uid)
    }
    
}
