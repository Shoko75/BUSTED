//
//  InviteFriendsViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-26.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

protocol InviteFriendsDelegate {
    func didFinishObserveUserInfo()
}

protocol ToCellInviteFriendsDelegate {
    func didSendFriendRequest()
}

class InviteFriendsViewModel {
    
    let SECTION_REQUESTING = "Requesting"
    let SECTION_PEOPLE = "People"
    
    let userInfoRef = Database.database().reference(withPath: "user_Info")
    let friendReqRef = Database.database().reference(withPath: "friends_request")
    let userID = Auth.auth().currentUser?.uid
    
    var dbFriendReq: DBFriendRequest!
    var inviteFriendsDelegate: InviteFriendsDelegate?
    var toCellInviteFriendsDelegate: ToCellInviteFriendsDelegate?
    var dicPeopleAndReq = [String:[Friend]]()
    
    struct frindsWithSection {
        var sectionName: String
        var friends: [Friend]
    }
    var friendsList = [frindsWithSection]()
    
    func createFriendsList(){
        
        friendsList.removeAll()
        
        if let req = dicPeopleAndReq[SECTION_REQUESTING] {
            friendsList.append(frindsWithSection(sectionName: self.SECTION_REQUESTING, friends: req))
        }
        if let people = dicPeopleAndReq[SECTION_PEOPLE] {
            friendsList.append(frindsWithSection(sectionName: self.SECTION_PEOPLE, friends: people))
        }
    }
    
    func fetchPeopleInfo(exculudeUsers: [String:Int]?) {
        userInfoRef.observeSingleEvent(of: .value, with: { snapshot in
            var friends: [Friend] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let friend = Friend(snapshot: snapshot){
                    
                    // exculude the users that already requesting
                    if (exculudeUsers?[friend.uid]) == nil, friend.uid != self.userID {
                        friends.append(friend)
                    }
                }
            }
            self.dicPeopleAndReq[self.SECTION_PEOPLE] = friends
            self.createFriendsList()
            self.inviteFriendsDelegate?.didFinishObserveUserInfo()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func fetchFriendReq() {
        
        var requestingFriendID = [String:Int]()
        self.friendsList.removeAll()
        
        // Get the data which fromUser is myself
        friendReqRef.queryOrdered(byChild: "fromUser").queryEqual(toValue: userID).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let value = snapshot.value as? [String: Any],
                    let toUserID = value["toUser"] as? String {
                    
                    requestingFriendID[toUserID] = 0
                }
            }
            self.fetchUserInfoByID(reqFriendID: requestingFriendID)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // When there is no request, just show userList
        if requestingFriendID.isEmpty {
            self.fetchPeopleInfo(exculudeUsers: nil)
        }
        
    }
    
    func fetchUserInfoByID(reqFriendID: [String:Int]){
        var frineds: [Friend] = []
        
        for toUserID in reqFriendID.keys {
        userInfoRef.child(toUserID).observeSingleEvent(of: .value, with: { snapshot in
                
                if let friend = Friend(snapshot: snapshot) {
                    frineds.append(friend)
                }
                self.dicPeopleAndReq[self.SECTION_REQUESTING] = frineds
                self.fetchPeopleInfo(exculudeUsers: reqFriendID)
            })
        }
    }
    
    func sendFrinedRequest(friend: Friend){
        
        let userID = Auth.auth().currentUser?.uid
        self.dbFriendReq = DBFriendRequest(fromUser: userID!, toUser: friend.uid, status: "request")
        
        let request = friendReqRef.childByAutoId()
        request.setValue(self.dbFriendReq.toAnyObject())
        toCellInviteFriendsDelegate?.didSendFriendRequest()
    }
}
