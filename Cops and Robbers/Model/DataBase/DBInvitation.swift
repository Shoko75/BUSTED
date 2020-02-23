//
//  DBInvitation.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-20.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

// MARK: DBInvitation
struct DBInvitation {
    
    let adminUser: String
    let status: String
    let dbPlayers: [DBPlayer]
    
    init(players: [DBPlayer], adminUser: String, status: String) {
        self.dbPlayers = players
        self.adminUser = adminUser
        self.status = status
    }
    
    func toAnyObject() -> Any {
        
        var dbPlayer = [String:Any]()
        for player in dbPlayers {
            dbPlayer[player.userId] = player.toAnyObject()
        }
        
        return [
            "status": status,
            "adminUser": adminUser,
            "player": dbPlayer
        ]
    }
}

// MARK: DBPlayer
struct DBPlayer {
    let userId: String
    let token: String
    let status: String
    
    init (userId: String ,token: String, status: String) {
        self.userId = userId
        self.token = token
        self.status = status
    }
    
    func toAnyObject() -> Any {
        
        return [
            "token": token,
            "status": status
        ]
    }
}
