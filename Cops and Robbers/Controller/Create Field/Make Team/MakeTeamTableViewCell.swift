//
//  MakeTeamTableViewCell.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-28.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class MakeTeamTableViewCell: UITableViewCell {

    @IBOutlet weak var copsImageView: UIImageView!
    @IBOutlet weak var copsNameLable: UILabel!
    @IBOutlet weak var robbersImageView: UIImageView!
    @IBOutlet weak var robbersNameLable: UILabel!
    
    func setCupsValues( cop: Player ) {
        copsNameLable.text = cop.user?.userName
        copsImageView.contentMode = .scaleToFill
        
        if let userImageURL = cop.user?.userImageURL {
            copsImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
        }
    }
    
    func setrobbersValues( robber: Player ) {
        robbersNameLable.text = robber.user?.userName
        robbersImageView.contentMode = .scaleToFill
        
        if let userImageURL = robber.user?.userImageURL {
            robbersImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
        }
    }
}
