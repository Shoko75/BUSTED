//
//  LoadGameViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-31.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

protocol LoadGameDelegate {
    func didCreateGame()
}

class LoadGameViewModel {
    
    let gameRef = Database.database().reference(withPath: "game")
    let occupiedMajorRef = Database.database().reference(withPath: "occupied _major")
    var occupiedMajors = [String]()
    var loadGameDelegate :LoadGameDelegate?
    
    func observeOccupiedMajor() {
        occupiedMajorRef.observe(.value) { (snapshot) in
            
            guard snapshot.exists() else { return }
            
            for value in snapshot.children {
                self.occupiedMajors.append(value as! String)
            }
        }
    }
    
    func prepareForGame(currentLoction: DBField, playersInfo: [Player], gameID: String) {
        
        // FieldLocation
        let fieldLocation = DBField(latitude: currentLoction.latitude, longitude: currentLoction.longitude)
        
        // Generate Major
        let majors = generateMajor()
        
        // CreateTeam
        let (cops, robbers) = createTeam(playersInfo: playersInfo, majors: majors)
        
        let gameData = DBGame(field: fieldLocation, cops: cops, robbers: robbers)
        
        // Register Game
        registerGame(registerData: gameData, gameID: gameID)
    }
    
    
    func generateMajor() -> [String] {
        
        var flgOK = false
        var newMajors = [String]()
        
        while flgOK == false {
            
            let major1 = Int.random(in: 1...300)
            let major2 = Int.random(in: 1...300)
            newMajors = [String(major1),String(major2)]
            
            if occupiedMajors.count != 0 {
                for newMajor in newMajors {
                    for occupiedMajor in occupiedMajors {
                        
                        if newMajor == occupiedMajor {
                            break
                        }
                    }
                }
                flgOK = true
            } else {
                flgOK = true
            }
        }
        
        registerMajor(majors: newMajors)
        
        return newMajors
    }
    
    func createTeam(playersInfo: [Player], majors: [String]) -> (DBCops, DBRobber) {
        var passedData = playersInfo
        var copsPlayer = [String]()
        var robbersPlayer = [DBRobPlayer]()
        var cnt = 0
        
        passedData.shuffle()
        
        for player in passedData {
            if cnt % 2 == 0 {
                copsPlayer.append(player.playerID)
            } else {
                robbersPlayer.append(DBRobPlayer(userId: player.playerID, status: "Alive"))
            }
            cnt += 1
        }
        
        let cops = DBCops(major: majors[0], points: 0, players: copsPlayer)
        let robbers = DBRobber(major: majors[1], points: 0, players: robbersPlayer)
        
        return (cops, robbers)
    }
    
    func registerMajor(majors: [String]) {
        
        for major in majors {
            occupiedMajorRef.child(major).setValue("")
        }
    }
    
    func registerGame(registerData: DBGame, gameID: String) {
        
        let request = gameRef.child(gameID)
        request.setValue(registerData.toAnyObject())
        
        loadGameDelegate?.didCreateGame()
    }
    
    func observeGame(gameID: String) {
        gameRef.child(gameID).observe(.value) { (snapshot) in
            
            guard snapshot.exists() else { return }

            print("the game data was created")
            self.loadGameDelegate?.didCreateGame()
        }
    }
}

