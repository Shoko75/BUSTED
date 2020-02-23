//
//  AddPlayersTableViewCell.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-12.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

// MARK: Protocol
protocol AddPlayerTableViewCellDelegate {
    func pressedAdd(player: Friend)
}

// MARK: AddPlayerTableViewCell
class AddPlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addedButton: UIButton!

    fileprivate var addPlayerViewModel = AddPlayerViewModel()
    
    var cellValues: Friend!
    var addPlayerTableViewCellDelegate: AddPlayerTableViewCellDelegate?
    
    func setCellValues(cellValues: Friend, bStatus: Bool){
        self.cellValues = cellValues
        
        userNameLabel.text = cellValues.userName
        userImageView.contentMode = .scaleToFill
        addedButton.isEnabled = bStatus
        if bStatus {
            addedButton.setImage(UIImage(named: "Button_Add"), for: .normal)
        } else {
            addedButton.setImage(UIImage(named: "Button_added"), for: .normal)
        }
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
        if let userImageURL = cellValues.userImageURL {
            userImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
        }
    }
    
    @IBAction func pressedAddButton(_ sender: Any) {
        addedButton.isEnabled = false
        addedButton.setImage(UIImage(named: "Button_added"), for: .normal)
        addPlayerTableViewCellDelegate?.pressedAdd(player: self.cellValues)
    }
}
