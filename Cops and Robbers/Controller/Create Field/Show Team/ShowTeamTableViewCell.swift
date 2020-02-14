//
//  ShowTeamTableViewCell.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-28.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class ShowTeamTableViewCell: UITableViewCell {

    @IBOutlet weak var copsImageView: UIImageView!
    @IBOutlet weak var copsNameLable: UILabel!
    @IBOutlet weak var robbersImageView: UIImageView!
    @IBOutlet weak var robbersNameLable: UILabel!
    
    func setCupsValues( cop: CopPlayer ) {
        copsNameLable.text = cop.userName
        copsImageView.contentMode = .scaleToFill
        copsImageView.layer.masksToBounds = true
        copsImageView.layer.cornerRadius = copsImageView.bounds.width / 2
        if let userImageURL = cop.userImageURL, userImageURL != "" {
            copsImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
        }
    }
    
    func setrobbersValues( robber: RobPlayer ) {
        robbersNameLable.text = robber.userName
        robbersImageView.contentMode = .scaleToFill
        robbersImageView.layer.masksToBounds = true
        robbersImageView.layer.cornerRadius = robbersImageView.bounds.width / 2
        if let userImageURL = robber.userImageURL, userImageURL != "" {
            robbersImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
        }
    }
}
