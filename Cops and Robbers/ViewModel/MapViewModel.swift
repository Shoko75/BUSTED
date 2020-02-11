//
//  MapViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-12.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

protocol MapDelegate {
    func didObserve()
}

class MapViewModel {
    
    let gameRef = Database.database().reference(withPath: "game")
    
    var enemys = [UserForGame]()
    var gameID = ""
    var flgCops: Bool?
    var gameData: Game?
    var mapDelegate: MapDelegate?
    
    func setEnemyData(gameData: Game) {
        
        if flgCops! {
            
            for enemy in gameData.robbers.robPlayers {
                
                let data = UserForGame(name: enemy.userName!, icon: enemy.userImageURL ?? "", uuid:
                    UUID(uuidString: enemy.gameUuid)!, majorValue: Int(gameData.robbers.major)!, minorValue: 1)
                enemys.append(data)
            }
            
        } else {
            for enemy in gameData.cops.players {
                
                let data = UserForGame(name: enemy.userName!, icon: enemy.userImageURL ?? "", uuid:
                    UUID(uuidString: enemy.gameUuid)!, majorValue: Int(gameData.cops.major)!, minorValue: 1)
                
                enemys.append(data)
            }
        }
    }
    
    func searchMyGameUuid(gameData: Game) -> String {
        
        let userID = Auth.auth().currentUser?.uid
        var gameUuid = ""
        
        if flgCops! {
            for player in gameData.cops.players {
                if player.userId == userID {
                    gameUuid = player.gameUuid
                }
            }
        } else {
            for player in gameData.robbers.robPlayers {
                if player.userId == userID {
                    gameUuid = player.gameUuid
                }
            }
        }
        
        return gameUuid
    }
    
    func controlProcessingByProximity(gameUuid: String) {
        updateRobberStatus(gameUuid: gameUuid)
    }
    
    func updateRobberStatus(gameUuid: String) {
        
        let status = ["status": "Jail"]
        
        for player in (gameData?.robbers.robPlayers)! {
            
            if player.gameUuid == gameUuid, player.status != "Jail" {
                gameRef.child(gameID).child("robbers").child("player").child(player.userId).updateChildValues(status)
            }
        }
        
    }
    
    func observeGame() {
        gameRef.child(gameID).observe(.value) { (snapshot) in
            
            if let gameData = Game(snapshot: snapshot) {
                self.gameData = gameData
            }
        }
    }
}
