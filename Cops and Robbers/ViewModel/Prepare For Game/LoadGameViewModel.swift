//
//  LoadGameViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-31.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//
import Firebase
import MapKit

// MARK: protocol -LoadGameDelegate
protocol LoadGameDelegate {
    func didCreateGame()
}

// MARK: LoadGameViewModel
class LoadGameViewModel {
    
    private let gameRef = Database.database().reference(withPath: "game")
    private let occupiedMajorRef = Database.database().reference(withPath: "occupied _major")
    private let invitationRef = Database.database().reference(withPath: "invitation")
    
    let userID = Auth.auth().currentUser?.uid
    var occupiedMajors = [String]()
    var loadGameDelegate :LoadGameDelegate?
    
    // MARK: Observing
    func observeOccupiedMajor() {
        occupiedMajorRef.observe(.value) { (snapshot) in
            
            guard snapshot.exists() else { return }
            
            for child in snapshot.children {
                guard let value = child as? DataSnapshot else { return }
                self.occupiedMajors.append(value.key)
            }
        }
    }
    
    func observeGame(gameID: String) {
        gameRef.child(gameID).observe(.value) { (snapshot) in
            
            guard snapshot.exists() else { return }

            print("the game data was created")
            self.loadGameDelegate?.didCreateGame()
        }
    }
    
    func stopObserveGame(gameID: String) {
        gameRef.child(gameID).removeAllObservers()
    }
    
    // MARK: Registration
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
    
    // MARK: Delete
    func deleteInvitation(gameID: String) {
        invitationRef.child(gameID).removeValue()
    }
    
    // MARK: Others
    func prepareForGame(currentLoction: CLLocation, playersInfo: [Player], gameID: String) {
        
        // FieldLocation
        let fieldLocation = DBField(latitude: String(currentLoction.coordinate.latitude), longitude: String(currentLoction.coordinate.longitude))
        
        // Generate Major
        let majors = generateMajor()
        
        // CreateTeam
        let (cops, robbers) = createTeam(playersInfo: playersInfo, majors: majors)
        
        let flags = generateFlags(currentLoction: currentLoction)
        
        let gameData = DBGame(field: fieldLocation, cops: cops, robbers: robbers, flags: flags, admin: userID!)
        
        // Register Game
        registerGame(registerData: gameData, gameID: gameID)
        deleteInvitation(gameID: gameID)
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
        var copsPlayer = [DBCopPlayer]()
        var robbersPlayer = [DBRobPlayer]()
        var cnt = 0
        
        passedData.shuffle()
        
        for player in passedData {
            if cnt % 2 == 0 {
                let uuid = UUID().uuidString
                copsPlayer.append(DBCopPlayer(userId: player.playerID, gameUuid: uuid))
            } else {
                let uuid = UUID().uuidString
                robbersPlayer.append(DBRobPlayer(userId: player.playerID, status: "Alive", gameUuid: uuid))
            }
            cnt += 1
        }
        
        let cops = DBCops(major: majors[0], points: 0, players: copsPlayer)
        let robbers = DBRobber(major: majors[1], points: 0, players: robbersPlayer)
        
        return (cops, robbers)
    }
    
    func generateFlags(currentLoction: CLLocation) -> [DBFlag] {

        var cnt = 0
        var flags = [DBFlag]()
        
        //First we declare While to repeat adding Annotation
        while cnt != 3 {
              cnt += 1

            //Add Annotation
            let flag = generateRandomCoordinates(min: 0, max: 500, currentLoction: currentLoction) //this will be the maximum and minimum distance of the annotation from the current Location (Meters)
            flags.append(DBFlag(latitude: String(flag.latitude), longitude: String(flag.longitude)))

        }
        
        return flags
    }
    
    func generateRandomCoordinates(min: UInt32, max: UInt32, currentLoction: CLLocation)-> CLLocationCoordinate2D {
        //Get the Current Location's longitude and latitude
        let currentLong = currentLoction.coordinate.longitude
        let currentLat = currentLoction.coordinate.latitude

        //1 KiloMeter = 0.00900900900901° So, 1 Meter = 0.00900900900901 / 1000
        let meterCord = 0.00900900900901 / 1000

        //Generate random Meters between the maximum and minimum Meters
        let randomMeters = UInt(arc4random_uniform(max) + min)

        //then Generating Random numbers for different Methods
        let randomPM = arc4random_uniform(6)

        //Then we convert the distance in meters to coordinates by Multiplying the number of meters with 1 Meter Coordinate
        let metersCordN = meterCord * Double(randomMeters)
        
        //here we generate the last Coordinates
        if randomPM == 0 {
            return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong + metersCordN)
        }else if randomPM == 1 {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong - metersCordN)
        }else if randomPM == 2 {
            return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong - metersCordN)
        }else if randomPM == 3 {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong + metersCordN)
        }else if randomPM == 4 {
            return CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong - metersCordN)
        }else {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong)
        }
    }
}

