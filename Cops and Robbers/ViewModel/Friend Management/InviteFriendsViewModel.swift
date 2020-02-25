//
//  InviteFriendsViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-26.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//
import Firebase

// MARK: Protocol -InviteFriendsDelegate
protocol InviteFriendsDelegate {
    func didFinishObserveUserInfo()
}

// MARK: InviteFriendsViewModel
class InviteFriendsViewModel {
    
    let SECTION_REQUESTING = "Requesting"
    let SECTION_PEOPLE = "People"
    
    private let userInfoRef = Database.database().reference(withPath: "user_Info")
    private let friendReqRef = Database.database().reference(withPath: "friends_request")
    private let friendsRef = Database.database().reference(withPath: "friends")
    private let userID = Auth.auth().currentUser?.uid
    
    var dbFriendReq: DBFriendRequest!
    var inviteFriendsDelegate: InviteFriendsDelegate?
    var dicPeopleAndReq = [String:[(Friend,Bool)]]() // Bool = isRequestedFlg
    var exculudeUsers = [String]()
    
    struct frindsWithSection {
        var sectionName: String
        var friends: [(Friend,Bool)]
    }
    
    var friendsList = [frindsWithSection]()
    
    // MARK: Registration
    func createFriendsList(){
        
        friendsList.removeAll()
        
        if let req = dicPeopleAndReq[SECTION_REQUESTING] {
            friendsList.append(frindsWithSection(sectionName: self.SECTION_REQUESTING, friends: req))
        }
        if let people = dicPeopleAndReq[SECTION_PEOPLE] {
            friendsList.append(frindsWithSection(sectionName: self.SECTION_PEOPLE, friends: people))
        }
    }
    
    func registerFrinedRequest(friend: Friend){
        
        self.dbFriendReq = DBFriendRequest(fromUser: userID!, toUser: friend.uid, status: "request")
        
        let request = friendReqRef.childByAutoId()
        request.setValue(self.dbFriendReq.toAnyObject())
    }
    
    // MARK: Fetch
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
        var frineds: [(Friend, Bool)] = []
        
        for toUserID in reqFriendID {
            userInfoRef.child(toUserID).observeSingleEvent(of: .value, with: { snapshot in
                
                if let friend = Friend(snapshot: snapshot) {
                    frineds.append((friend, false))
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
            var friends: [(Friend,Bool)] = []
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
                            friends.append((friend,false))
                        }
                    } else {
                        
                        if friend.uid != self.userID {
                            friends.append((friend,false))
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
}
