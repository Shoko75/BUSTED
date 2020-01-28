//
//  WaitingPlayerViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-24.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

protocol WaitingPlayerDelegate {
    func didfetchData()
}

class WaitingPlayerViewModel {
    
    let gameRef = Database.database().reference(withPath: "game")
    let userInfoRef = Database.database().reference(withPath: "user_Info")
    var playerList = [Player]()
    var waitingPlayerDelegate: WaitingPlayerDelegate?
    
    func observeGameInfo(gameID: String){
        gameRef.child(gameID).observe(.value) { (snapshot) in
            if let value = snapshot.value as? [String: AnyObject],
                let members = value["member"] as? [String: AnyObject] {
                var players = [Player]()
                var dummyFriend: Friend?
                
                for member in members.keys {
                    if let value = members[member] as? [String:AnyObject],
                        let status = value["status"] as? String,
                        let token = value["token"] as? String {
                        players.append(Player(playerID: member, token: token, status: status, team: "", user: dummyFriend))
                    }
                }
                self.fetchUserInfoByID(players: players)
            }
        }
    }
    
    func fetchUserInfoByID(players: [Player]) {
        var temPlayer: [Player] = []
        
        for player in players {
            userInfoRef.child(player.playerID).observeSingleEvent(of: .value, with: { snapshot in
                
                if let friend = Friend(snapshot: snapshot) {
                    temPlayer.append(Player(playerID: player.playerID, token: player.token, status: player.status, team: player.team, user: friend))
                }
                self.playerList = temPlayer
                self.waitingPlayerDelegate?.didfetchData()
            })
        }
    }
}
