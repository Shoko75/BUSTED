//
//  DBGame.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-31.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Foundation

struct DBGame {
    let field: DBField
    let cops: DBCops
    let robbers: DBRobber
    
    init(field: DBField, cops: DBCops, robbers: DBRobber){
        self.field = field
        self.cops = cops
        self.robbers = robbers
    }
    
    func toAnyObject() -> Any {
        
        return [
            "feild": field.toAnyObject(),
            "cops": cops.toAnyObject(),
            "robbers": robbers.toAnyObject()
        ]
    }
}

struct DBField {
    
    let latitude: String
    let longitude: String
    
    init(latitude: String, longitude: String) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func toAnyObject() -> Any {
        
        return [
            "latitude": latitude,
            "longitude": longitude
        ]
    }
}

struct DBCops {
    let major: String
    let players: [String]
    let points: Int
    
    init(major: String, points: Int, players: [String]) {
        self.major = major
        self.players = players
        self.points = points
    }
    
    func toAnyObject() -> Any {
        
        var dbPlayer = [String:Any]()
        for player in players {
            dbPlayer[player] = ""
        }
        
        return [
            "major": major,
            "points": points,
            "player": dbPlayer
        ]
    }
}

struct DBRobber {
    let major: String
    let dbRobPlayers: [DBRobPlayer]
    let points: Int
    
    init(major: String, points: Int, players: [DBRobPlayer] ) {
        self.dbRobPlayers = players
        self.major = major
        self.points = points
    }
    
    func toAnyObject() -> Any {
        
        var dbPlayer = [String:Any]()
        for player in dbRobPlayers {
            dbPlayer[player.userId] = player.toAnyObject()
        }
        
        return [
            "major": major,
            "points": points,
            "player": dbPlayer
        ]
    }
}

struct DBRobPlayer {
    let userId: String
    let status: String
    
    init (userId: String , status: String) {
        self.userId = userId
        self.status = status
    }
    
    func toAnyObject() -> Any {
        
        return [
            "status": status
        ]
    }
}