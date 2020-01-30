//
//  WaitingPlayerAdminViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-24.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

protocol WaitingPlayerAdminDelegate {
    func didfetchData()
    func didCreatePassData()
}

class WaitingPlayerAdminViewModel {
    
    let invitationRef = Database.database().reference(withPath: "invitation")
    let userInfoRef = Database.database().reference(withPath: "user_Info")
    let userID = Auth.auth().currentUser?.uid
    
    var playerList = [Player]()
    var waitingPlayerAdminDelegate: WaitingPlayerAdminDelegate?
    var invitationID: String?
    
    func observeInvitation() {
        invitationRef.child(invitationID!).observe(.value) { (snapshot) in
            if let value = snapshot.value as? [String: AnyObject],
                let members = value["player"] as? [String: AnyObject] {
                var players = [Player]()
                var dummyFriend: Friend?
                
                for member in members.keys {
                    if let value = members[member] as? [String:AnyObject],
                        let status = value["status"] as? String {
                        players.append(Player(playerID: member, status: status, user: dummyFriend))
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
                    temPlayer.append(Player(playerID: player.playerID, status: player.status, user: friend))
                }
                if cnt == players.count {
                    self.playerList = temPlayer
                    self.waitingPlayerAdminDelegate?.didfetchData()
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
                let request = invitationRef.child(invitationID!).child("player").child(player.playerID)
                request.removeValue()
            }
        }
        playerList = joinedPlayers
        fetchAdminUserInfo()
    }
    
    func fetchAdminUserInfo() {
        userInfoRef.child(userID!).observeSingleEvent(of: .value, with: { snapshot in
            if let friend = Friend(snapshot: snapshot) {
                let adminUser = Player(playerID: friend.uid, status: "Joined", user: friend)
                self.updateInvitationPlayer(updateInfo: adminUser)
                self.playerList.append(adminUser)
                self.updateInvitationStatus()
                self.waitingPlayerAdminDelegate?.didCreatePassData()
            }
        })
    }
    
    func updateInvitationPlayer(updateInfo: Player) {
       
        let adminData = DBPlayer(userId: updateInfo.playerID, token: updateInfo.user!.token, status: updateInfo.status)
        
        let request = invitationRef.child(invitationID!).child("player").child(adminData.userId)
        request.setValue(adminData.toAnyObject())
        
    }
    
    func updateInvitationStatus(){
        
        let request = invitationRef.child(invitationID!).child("status")
        request.setValue("Start")
    }
    
    func deleteInvitation(){
        invitationRef.child(invitationID!).removeValue()
    }
    
    func stopObserve() {
        invitationRef.child(invitationID!).removeAllObservers()
    }
    
}
