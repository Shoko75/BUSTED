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
    func didRegisterFriendRequest()
}

class InviteFriendsViewModel {
    
    let SECTION_REQUESTING = "Requesting"
    let SECTION_PEOPLE = "People"
    
    let userInfoRef = Database.database().reference(withPath: "user_Info")
    let friendReqRef = Database.database().reference(withPath: "friends_request")
    let friendsRef = Database.database().reference(withPath: "friends")
    let userID = Auth.auth().currentUser?.uid
    
    var dbFriendReq: DBFriendRequest!
    var inviteFriendsDelegate: InviteFriendsDelegate?
    var toCellInviteFriendsDelegate: ToCellInviteFriendsDelegate?
    var dicPeopleAndReq = [String:[Friend]]()
    var exculudeUsers = [String]()
    
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
    
    func fetchFriendReqFromUserMyself() {
        
        var requestingFriendID = [String]()
        
        // Get the data which fromUser is myself
        friendReqRef.queryOrdered(byChild: "fromUser").queryEqual(toValue: userID).observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let value = snapshot.value as? [String: Any],
                    let toUserID = value["toUser"] as? String {
                    
                    requestingFriendID.append(toUserID)
                    self.exculudeUsers.append(toUserID)
                }
            }
            self.fetchUserInfoByID(reqFriendID: requestingFriendID)
            self.fetchFriendReqToUserMyself()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func fetchFriendReqToUserMyself() {
        
        friendReqRef.queryOrdered(byChild: "toUser").queryEqual(toValue: userID).observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let value = snapshot.value as? [String: Any],
                    let fromUserID = value["fromUser"] as? String {
                    
                    self.exculudeUsers.append(fromUserID)
                }
            }
            self.fetchFriends()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func fetchUserInfoByID(reqFriendID: [String]){
        var frineds: [Friend] = []
        
        for toUserID in reqFriendID {
            userInfoRef.child(toUserID).observeSingleEvent(of: .value, with: { snapshot in
                
                if let friend = Friend(snapshot: snapshot) {
                    frineds.append(friend)
                }
                self.dicPeopleAndReq[self.SECTION_REQUESTING] = frineds
            })
        }
    }
    
    func fetchFriends() {
        
        friendsRef.child(userID!).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    self.exculudeUsers.append(snapshot.key)
                }
            }
            
            self.fetchPeopleInfo()
        })
    }
    
    func fetchPeopleInfo() {
        userInfoRef.observeSingleEvent(of: .value, with: { snapshot in
            var friends: [Friend] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let friend = Friend(snapshot: snapshot){
                    
                    if self.exculudeUsers.count != 0 {
                        var cnt = 0
                        for exculudeUser in self.exculudeUsers {
                            // exculude the users that already requesting
                            if exculudeUser != friend.uid, friend.uid != self.userID {
                                cnt += 1
                            }
                        }
                        
                        if cnt == self.exculudeUsers.count {
                            friends.append(friend)
                        }
                    } else {
                        
                        if friend.uid != self.userID {
                            friends.append(friend)
                        }
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
    
    func registerFrinedRequest(friend: Friend){
        
        self.dbFriendReq = DBFriendRequest(fromUser: userID!, toUser: friend.uid, status: "request")
        
        let request = friendReqRef.childByAutoId()
        request.setValue(self.dbFriendReq.toAnyObject())
        toCellInviteFriendsDelegate?.didRegisterFriendRequest()
    }
}
