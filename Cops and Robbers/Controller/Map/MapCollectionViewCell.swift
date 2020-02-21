//
//  MapCollectionViewCell.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-02-11.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class MapCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    func setCellValues(name: String, userImageURL: String) {
        userNameLabel.text = name
        userImageView.contentMode = .scaleToFill
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
        userImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
    }
}
