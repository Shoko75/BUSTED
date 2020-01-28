//
//  DBGame.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-20.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Foundation

struct DBGame {
    
    let dbPlayers: [DBPlayer]
    let dbTeamStatus: DBTeamStatus
    let adminUser: String
    
    init(players: [DBPlayer], teamStatus: DBTeamStatus, adminUser: String) {
        self.dbPlayers = players
        self.dbTeamStatus = teamStatus
        self.adminUser = adminUser
    }
    
    func toAnyObject() -> Any {
        
        var dbPlayer = [String:Any]()
        for player in dbPlayers {
            dbPlayer[player.userId] = player.toAnyObject()
        }
        
        return [
            "adminUser": adminUser,
            "member": dbPlayer,
            "teamStatus": dbTeamStatus.toAnyObject()
        ]
    }
}

struct DBPlayer {
    let userId: String
    let token: String
    let team: String?
    let status: String
    
    init (userId: String ,token: String, team: String, status: String) {
        self.userId = userId
        self.token = token
        self.team = team
        self.status = status
    }
    
    func toAnyObject() -> Any {
        
        return [
            "token": token,
            "team": team,
            "status": status
        ]
    }
}

struct DBTeamStatus {
    let pTeamLeft: Int?
    let rTeamLeft: Int?
    
    init(pTeamLeft: Int, rTeamLeft: Int) {
        self.pTeamLeft = pTeamLeft
        self.rTeamLeft = rTeamLeft
    }
    
    func toAnyObject() -> Any {
        return [
            "pTeamLeft": pTeamLeft,
            "rTeamLeft": rTeamLeft
        ]
    }
}
