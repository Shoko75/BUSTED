//
//  MapViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-12.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

class MapViewModel {
    
    var enemys = [UserForGame]()
    
    func setEnemyData(gameData:Game, flgCops: Bool) {
        
        if flgCops {
            
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
    
    func searchMyGameUuid(gameData: Game, flgCops: Bool) -> String {
        
        let userID = Auth.auth().currentUser?.uid
        var gameUuid = ""
        
        if flgCops {
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
}
