//
//  Game.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-24.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//
import Firebase

struct Player {
    let playerID: String
    let status: InvitationStatus
    let user: Friend?
    
    init( playerID: String, status: InvitationStatus, user:Friend? ) {
        self.playerID = playerID
        self.status = status
        self.user = user
    }
}

enum InvitationStatus: String {
    case Waiting
    case Joined
    case Declined
}

