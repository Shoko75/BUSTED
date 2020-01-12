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
    let userID = Auth.auth().currentUser?.uid

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
                self.playerList = frineds
                self.addPlayerDelegate?.didFinishFetchData()
            })
        }
    }
}
