//
//  MapViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-12.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Foundation
import CoreLocation

class MapViewModel {
    
    var users = [User]()
    
    
    init(user: User){
        self.users.append(user)
    }
    
    
}
