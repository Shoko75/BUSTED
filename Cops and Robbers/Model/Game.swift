//
//  Game.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-24.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

struct Player {
    let playerID: String
    let token: String
    let status: String
    let team: String?
    let user: Friend?
    
    init( playerID: String, token: String, status: String, team: String?, user:Friend? ) {
        self.playerID = playerID
        self.token = token
        self.status = status
        self.team = team
        self.user = user
    }
}

