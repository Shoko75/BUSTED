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
    let flags: [DBFlag]
    let admin: String
    
    init(field: DBField, cops: DBCops, robbers: DBRobber, flags: [DBFlag], admin: String){
        self.field = field
        self.cops = cops
        self.robbers = robbers
        self.flags = flags
        self.admin = admin
    }
    
    func toAnyObject() -> Any {
        
        var dbFlags = [[String:Any]]()
        for flag in flags {
            dbFlags.append(flag.toAnyObject() as! [String : Any])
        }
        
        return [
            "feild": field.toAnyObject(),
            "cops": cops.toAnyObject(),
            "robbers": robbers.toAnyObject(),
            "flags": dbFlags,
            "admin": admin
        ]
    }
}

struct DBFlag {
    let latitude: String
    let longitude: String
    let activeFlg: Bool
    
    init(latitude: String, longitude: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.activeFlg = true
    }
    
    func toAnyObject() -> Any {
        
        return [
            "latitude": latitude,
            "longitude": longitude,
            "activeFlg": activeFlg
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
    let players: [DBCopPlayer]
    let points: Int
    
    init(major: String, points: Int, players: [DBCopPlayer]) {
        self.major = major
        self.players = players
        self.points = points
    }
    
    func toAnyObject() -> Any {
        
        var dbPlayer = [String:Any]()
        for player in players {
            dbPlayer[player.userId] = player.toAnyObject()
        }
        
        return [
            "major": major,
            "points": points,
            "player": dbPlayer
        ]
    }
}

struct DBCopPlayer {
    let userId: String
    let gameUuid: String
    
    init (userId: String , gameUuid: String) {
        self.userId = userId
        self.gameUuid = gameUuid
    }
    
    func toAnyObject() -> Any {
        
        return [
            "gameUuid": gameUuid
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
    let gameUuid: String
    
    init (userId: String , status: String, gameUuid: String) {
        self.userId = userId
        self.status = status
        self.gameUuid = gameUuid
    }
    
    func toAnyObject() -> Any {
        
        return [
            "status": status,
            "gameUuid": gameUuid
        ]
    }
}
