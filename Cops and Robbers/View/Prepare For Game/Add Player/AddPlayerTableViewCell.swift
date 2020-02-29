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
    func didPressAdd(indexPath: IndexPath)
}

// MARK: AddPlayerTableViewCell
class AddPlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addedButton: UIButton!
    
    var addPlayerTableViewCellDelegate: AddPlayerTableViewCellDelegate?
    var indexPath:IndexPath?
    
    @IBAction func pressedAddButton(_ sender: Any) {
        addPlayerTableViewCellDelegate?.didPressAdd(indexPath: indexPath!)
    }
}
