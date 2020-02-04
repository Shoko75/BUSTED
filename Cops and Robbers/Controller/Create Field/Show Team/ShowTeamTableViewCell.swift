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
        
        if let userImageURL = cop.userImageURL {
            copsImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
        }
    }
    
    func setrobbersValues( robber: RobPlayer ) {
        robbersNameLable.text = robber.userName
        robbersImageView.contentMode = .scaleToFill
        
        if let userImageURL = robber.userImageURL {
            robbersImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
        }
    }
}
