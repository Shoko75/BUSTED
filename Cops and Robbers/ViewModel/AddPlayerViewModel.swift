//
//  AddPlayerViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-12.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

protocol AddPlayerDelegate {
    func didFinishFetchData()
}

class AddPlayerViewModel {
    
    let userInfoRef = Database.database().reference(withPath: "user_Info")
    let friendsRef = Database.database().reference(withPath: "friends")
    let gameRef = Database.database().reference(withPath: "game")
    let userID = Auth.auth().currentUser?.uid

    var friendList = [Friend]()
    var playerList = [Friend]()
    var addPlayerDelegate: AddPlayerDelegate?
    
    func fetchFriends(){
        var friendsID = [String]()
        
        friendsRef.child(userID!).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    friendsID.append(snapshot.key)
                }
            }
            self.fetchUserInfoByID(idKeys: friendsID)
        }) { (error) in
                print(error.localizedDescription)
        }
    }
    
    func fetchUserInfoByID(idKeys: [String]){
        var frineds: [Friend] = []
        
        for idKey in idKeys {
            userInfoRef.child(idKey).observeSingleEvent(of: .value, with: { snapshot in
                
                if let friend = Friend(snapshot: snapshot) {
                    frineds.append(friend)
                }
                self.friendList = frineds
                self.addPlayerDelegate?.didFinishFetchData()
            })
        }
    }
    
    func registerNewGame(){
        var members = [Member]()
        
        for player in playerList {
            let member = Member(userId: player.uid, token: player.token, team: "", status: "Waiting")
            members.append(member)
        }
        
        let teamStatus = TeamStatus(pTeamLeft: Int(), rTeamLeft: Int())
        let game = DBGame(member: members, teamStatus: teamStatus)
        
        let request = gameRef.childByAutoId()
        request.setValue(game.toAnyObject())
        
    }
    
}
