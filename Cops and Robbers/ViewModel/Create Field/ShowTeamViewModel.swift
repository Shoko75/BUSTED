//
//  ShowTeamViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-28.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

protocol ShowTeamDelegate {
    func didFetchGame()
}

class ShowTeamViewModle {
    let gameRef = Database.database().reference(withPath: "game")
    let userInfoRef = Database.database().reference(withPath: "user_Info")
    
    var cops: Cops?
    var robbers: Robbers?
    var showTeamDelegate: ShowTeamDelegate?
    
    
    func fetchGame(gameID: String) {
        gameRef.child(gameID).observeSingleEvent(of: .value) { (snapshot) in
            guard let game = Game(snapshot: snapshot) else { return }
            
            self.cops = game.cops
            self.robbers = game.robbers
            self.fetchUserInfoByID()
        }
    }
    
    func fetchUserInfoByID() {
        var copsCnt = 0
        var robbersCnt = 0
        
        for player in cops!.players {
            userInfoRef.child(player.userId).observeSingleEvent(of: .value, with: { snapshot in
                if let friend = Friend(snapshot: snapshot) {
                    self.cops?.players[copsCnt].userName = friend.userName
                    self.cops?.players[copsCnt].userImageURL = friend.userImageURL
                }
                copsCnt += 1
            })
        }
        
        for player in self.robbers!.robPlayers {
            userInfoRef.child(player.userId).observeSingleEvent(of: .value, with: { snapshot in
                if let friend = Friend(snapshot: snapshot) {
                    self.robbers?.robPlayers[robbersCnt].userName = friend.userName
                    self.robbers?.robPlayers[robbersCnt].userImageURL = friend.userImageURL
                }
                robbersCnt += 1
                if robbersCnt == self.robbers?.robPlayers.count {
                    self.showTeamDelegate?.didFetchGame()
                }
            })
        }
    }
}
