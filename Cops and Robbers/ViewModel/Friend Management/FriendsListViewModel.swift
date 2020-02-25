//
//  FriendsListViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-11.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//
import Firebase

// MARK: Protocol -FriendsListDelegate
protocol FriendsListDelegate {
    func didFinishFetchData()
}

// MARK: Protocol -ToCellfriendsListDelegate
protocol ToCellfriendsListDelegate {
    func didRegisterFriend()
}

// MARK: FriendsListViewModel
class FriendsListViewModel {
    
    let SECTION_REQUESTS = "Requests"
    let SECTION_FRIENDS = "Friends"
    
    private let userInfoRef = Database.database().reference(withPath: "user_Info")
    private let friendReqRef = Database.database().reference(withPath: "friends_request")
    private let friendsRef = Database.database().reference(withPath: "friends")
    private let userID = Auth.auth().currentUser?.uid
    
    var dicFriendsAndReq = [String:[(Friend, Bool)]]() // Bool = isAcceptedFlg
    var friendsListDelegate: FriendsListDelegate?
    var toCellFriendsListDelegate: ToCellfriendsListDelegate?
    var dbFriends: DBFriends!
    
    struct frindsWithSection {
        var sectionName: String
        var friends: [(Friend,Bool)]
    }
    var friendsList = [frindsWithSection]()
    
    // MARK: Registration
    func createFriendsList(){
        
        friendsList.removeAll()
        
        if let req = dicFriendsAndReq[SECTION_REQUESTS] {
            friendsList.append(frindsWithSection(sectionName: self.SECTION_REQUESTS, friends: req))
        }
        if let friends = dicFriendsAndReq[SECTION_FRIENDS] {
            friendsList.append(frindsWithSection(sectionName: self.SECTION_FRIENDS, friends: friends))
        }
    }
    
    func registerFriend(friendUID: String){
        
        // Myself
        let dbFriendsMine = DBFriends(uid: userID! ,friendUID: friendUID)
        let registerMyselfRef = self.friendsRef.child(dbFriendsMine.uid).child(dbFriendsMine.friendUID)
        registerMyselfRef.setValue(ServerValue.timestamp())
        
        // Opponent
        let dbFriendsOpponent = DBFriends(uid: friendUID ,friendUID: userID!)
        let registerOpponentfRef = self.friendsRef.child(dbFriendsOpponent.uid).child(dbFriendsOpponent.friendUID)
        registerOpponentfRef.setValue(ServerValue.timestamp())
        
        // Delete friend request
        deleteFriendRequest(friendUID: dbFriendsMine.friendUID)
    }
    
    // MARK: Fetch
    func fetchFriendReq() {
        var receivedFriendsID = [String]()
        
        // Get the data which toUser is myself
        friendReqRef.queryOrdered(byChild: "toUser").queryEqual(toValue: userID).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let value = snapshot.value as? [String: Any],
                    let fromUserID = value["fromUser"] as? String {
                    
                    receivedFriendsID.append(fromUserID)
                }
            }
            self.fetchUserInfoByID(idKeys: receivedFriendsID, sectionName: self.SECTION_REQUESTS)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func fetchFriends(){
        var friendsID = [String]()
        
        friendsRef.child(userID!).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    friendsID.append(snapshot.key)
                }
            }
            self.fetchUserInfoByID(idKeys: friendsID, sectionName: self.SECTION_FRIENDS)
        }) { (error) in
                print(error.localizedDescription)
        }
    }
    
    func fetchUserInfoByID(idKeys: [String], sectionName: String){
        var frineds: [(Friend, Bool)] = []
        
        for idKey in idKeys {
            userInfoRef.child(idKey).observeSingleEvent(of: .value, with: { snapshot in
                
                if let friend = Friend(snapshot: snapshot) {
                    frineds.append((friend, false))
                }
                
                if self.SECTION_REQUESTS == sectionName {
                    self.dicFriendsAndReq[self.SECTION_REQUESTS] = frineds
                } else if self.SECTION_FRIENDS == sectionName {
                    self.dicFriendsAndReq[self.SECTION_FRIENDS] = frineds
                }
                self.createFriendsList()
                self.friendsListDelegate?.didFinishFetchData()
            })
        }
    }
    
    // MARK: Delete
    func deleteFriendRequest(friendUID: String){
        
        // Get the data which toUser is my userID
        friendReqRef.queryOrdered(byChild: "toUser").queryEqual(toValue: userID).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let value = snapshot.value as? [String: Any],
                    let fromUserID = value["fromUser"] as? String {
                    
                    // When the fromUserId is friendID, delete the request data
                    if fromUserID == friendUID {
                        self.friendReqRef.child(snapshot.key).removeValue()
                        self.toCellFriendsListDelegate?.didRegisterFriend()
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
