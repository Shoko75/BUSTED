//
//  Game.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-02-01.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

struct Game {
    let field: Field
    let cops: Cops
    let robbers: Robbers
    
    init?(snapshot: DataSnapshot){
        
        guard
            let value = snapshot.value as? [String: AnyObject],
            let field = value["feild"] as? [String: AnyObject],
            let cops = value["cops"] as? [String: AnyObject],
            let robbers = value["robbers"] as? [String: AnyObject]
        else { return nil }
        
        self.field = Field(data: field)
        self.cops = Cops(data: cops)
        self.robbers = Robbers(data: robbers)
    }
}

struct Field {
    
    let latitude: String
    let longitude: String
    
    init(data: [String: AnyObject]) {
        self.latitude = data["latitude"] as! String
        self.longitude = data["longitude"] as! String
    }
}

struct Cops {
    let major: String
    var players: [CopPlayer]
    let points: Int
    
    init(data: [String: AnyObject]) {
        
        var cData = [CopPlayer]()
        let cPlayers = data["player"] as! [String: AnyObject]
        for cPlayer in cPlayers.keys {
            cData.append(CopPlayer(userId: cPlayer))
        }
        
        self.major = data["major"] as! String
        self.players = cData
        self.points = data["points"] as! Int
    }
    
    init(major: String, players: [String], points: Int) {
        
        var cData = [CopPlayer]()
        
        for player in players {
            cData.append(CopPlayer(userId: player))
        }
        
        self.major = major
        self.points = points
        self.players = cData
    }
}

struct CopPlayer {
    let userId: String
    var userName: String?
    var userImageURL: String?
    
    init(userId: String) {
        self.userId = userId
        self.userName = ""
        self.userImageURL = ""
    }
}

struct Robbers {
    let major: String
    var robPlayers: [RobPlayer]
    let points: Int
    
    init(data: [String: AnyObject]) {
        var robs = [RobPlayer]()
        let rPlayers = data["player"] as! [String:AnyObject]
        
        for rPlayer in rPlayers {
            let userID = rPlayer.key
            let data = rPlayer.value as! [String: AnyObject]
            
            robs.append(RobPlayer(data: data, userID: userID))
        }
        
        self.robPlayers = robs
        self.major = data["major"] as! String
        self.points = data["points"] as! Int
    }
    
    init(major: String, RobPlayers: [RobPlayer], points: Int) {
        self.major = major
        self.robPlayers = RobPlayers
        self.points = points
    }
}

struct RobPlayer {
    let userId: String
    let status: String
    var userName: String?
    var userImageURL: String?
    
    init (data: [String: AnyObject], userID: String) {
        self.userId = userID
        self.status = data["status"] as! String
        self.userName = ""
        self.userImageURL = ""
    }
}
