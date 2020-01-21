//
//  AddPlayersViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-12.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class AddPlayerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var addPlayerViewModel: AddPlayerViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addPlayerViewModel = AddPlayerViewModel()
        addPlayerViewModel.addPlayerDelegate = self
        addPlayerViewModel.fetchFriends()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(pressedNext))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func pressedNext() {
        print("Pressed Next!")
    }
}

// MARK: UITableViewDelegate
extension AddPlayerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addPlayerViewModel.friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddPlayersTableCell", for: indexPath) as! AddPlayerTableViewCell
        cell.addPlayerTableViewCellDelegate = self
        let friend = addPlayerViewModel.friendList[indexPath.row]
        let bStatus = checkButtonStatus(id: friend.uid)
        cell.setCellValues(cellValues: friend, bStatus: bStatus)
        return cell
    }
    
    func checkButtonStatus(id: String) -> Bool {
        
        for player in self.addPlayerViewModel.playerList {
        
            if player.uid == id {
                return false
            }
        }
        return true
    }
}

extension AddPlayerViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.addPlayerViewModel.playerList.count >= 1 {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        return self.addPlayerViewModel.playerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPlayersCollectionCell", for: indexPath) as! AddPlayerCollectionViewCell
        cell.addPlayerCollectionViewCellDelegate = self
        let player = addPlayerViewModel.playerList[indexPath.row]
        cell.setCellValues(cellValues: player)
        
        return cell
    }
    
    
}

// MARK: AddPlayerDelegate
extension AddPlayerViewController: AddPlayerDelegate {
    func didFinishFetchData() {
        self.tableView.reloadData()
    }
}

// MARK: AddPlayerTableViewCellDelegate
extension AddPlayerViewController: AddPlayerTableViewCellDelegate {
    func pressedAdd(player: Friend) {
        self.addPlayerViewModel.playerList.append(player)
        self.collectionView.reloadData()
    }
}

// MARK: AddPlayerCollectionViewCellDelegate
extension AddPlayerViewController: AddPlayerCollectionViewCellDelegate {
    func pressedDelete(id: String) {
        
        var cnt = 0
        for player in self.addPlayerViewModel.playerList {
            cnt += 1
            if player.uid == id {
                self.addPlayerViewModel.playerList.remove(at: cnt - 1)
                break
            }
        }
        
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    
}
