//
//  FriendsListViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-26.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

protocol FriendsListDelegate {
    func didFinishObserveUserInfo()
}

class FriendsListViewModel {
    
    let userInfoRef = Database.database().reference(withPath: "user_Info")
    
    var friendsList: [Friend]?
    var friendsListDelegate: FriendsListDelegate?
    
    func observeUserInfo() {
        
        userInfoRef.observe(.value, with: { snapshot in
            var friends: [Friend] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let friend = Friend(snapshot: snapshot) {
                    friends.append(friend)
                }
            }
            self.friendsList = friends
            self.friendsListDelegate?.didFinishObserveUserInfo()
        })
        
    }
}
