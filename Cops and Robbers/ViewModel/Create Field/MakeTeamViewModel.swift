//
//  MakeTeamViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-28.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Foundation

protocol MakeTeamDelegate {
    func didFinshCreateTeam()
}

class MakeTeamViewModle {
    
    var copsPlayer = [Player]()
    var robbersPlayer = [Player]()
    var makeTeamDelegate: MakeTeamDelegate?
    
    func createTeam(playersInfo: [Player]) {
        var passedData = playersInfo
        var cnt = 0
        
        passedData.shuffle()
        
        for player in passedData {
            if cnt % 2 == 0 {
                copsPlayer.append(player)
            } else {
                robbersPlayer.append(player)
            }
            cnt += 1
        }
        makeTeamDelegate?.didFinshCreateTeam()
    }
}
