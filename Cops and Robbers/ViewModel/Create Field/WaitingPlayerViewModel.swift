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
    func didCreatePassData()
}

class WaitingPlayerViewModel {
    
    let gameRef = Database.database().reference(withPath: "game")
    let userInfoRef = Database.database().reference(withPath: "user_Info")
    let userID = Auth.auth().currentUser?.uid
    
    var playerList = [Player]()
    var waitingPlayerDelegate: WaitingPlayerDelegate?
    var gameID: String?
    
    
    func observeGameInfo() {
        gameRef.child(gameID!).observe(.value) { (snapshot) in
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
        var cnt = 0
        
        for player in players {
            userInfoRef.child(player.playerID).observeSingleEvent(of: .value, with: { snapshot in
                cnt += 1
                if let friend = Friend(snapshot: snapshot) {
                    temPlayer.append(Player(playerID: player.playerID, token: player.token, status: player.status, team: player.team, user: friend))
                }
                if cnt == players.count {
                    self.playerList = temPlayer
                    self.waitingPlayerDelegate?.didfetchData()
                }
            })
        }
    }
    
    func createPassData(){
        var joinedPlayers = [Player]()
        for player in playerList {
            if player.status == "Joined" {
                joinedPlayers.append(player)
            } else if player.status == "Declined" {
                let request = gameRef.child(gameID!).child("member").child(player.playerID)
                request.removeValue()
            }
        }
        playerList = joinedPlayers
        fetchAdminUserInfo()
    }
    
    func fetchAdminUserInfo() {
        userInfoRef.child(userID!).observeSingleEvent(of: .value, with: { snapshot in
            if let friend = Friend(snapshot: snapshot) {
                let adminUser = Player(playerID: friend.uid, token: friend.token, status: "Joined", team: "", user: friend)
                self.updateGamePlayer(updateInfo: adminUser)
                self.playerList.append(adminUser)
                self.waitingPlayerDelegate?.didCreatePassData()
            }
        })
    }
    
    func updateGamePlayer(updateInfo: Player) {
       
        let adminData = DBPlayer(userId: updateInfo.playerID, token: updateInfo.token, team: "", status: updateInfo.status)
        
        let request = gameRef.child(gameID!).child("member").child(adminData.userId)
        request.setValue(adminData.toAnyObject())
        
    }
    
    func deleteGame(){
        gameRef.child(gameID!).removeValue()
    }
    
    func observeRemoveGame(){
        gameRef.child(gameID!).observe(.childRemoved) { (snapshot) in
            print(snapshot)
        }
    }
    
    func stopObserve() {
        gameRef.child(gameID!).removeAllObservers()
    }
    
}
