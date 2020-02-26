//
//  AddPlayersViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-12.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class AddPlayerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var customView: CustomUIView!
    
    fileprivate var addPlayerViewModel = AddPlayerViewModel()
    var invitationID: String?
    
    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegate
        addPlayerViewModel.addPlayerDelegate = self
        addPlayerViewModel.fetchFriends()
        
        // emptyDataSet Delegate
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(pressedNext))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        customView.roundCorners(cornerRadius: 50.0)
    }
    
    @objc func pressedNext() {
        print("Pressed Next!")
        
        self.addPlayerViewModel.checkInvitation()
    }
    
    // MARK: Button Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWaitingPlayerAdmin" {
            if let waitingPlayerAdminViewController = segue.destination as? WaitingPlayerAdminViewController {
                waitingPlayerAdminViewController.invitationID = self.invitationID
            }
        }
    }
    
    // MARK: Others
    func prepareInvitation() {
        self.invitationID = self.addPlayerViewModel.registerInvitation()
        self.addPlayerViewModel.updateUserPlayTeam(invitationID: self.invitationID!)
        self.performSegue(withIdentifier: "showWaitingPlayerAdmin", sender: nil)
    }
}

// MARK: UITableViewDelegate
extension AddPlayerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addPlayerViewModel.friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddPlayersTableCell", for: indexPath) as! AddPlayerTableViewCell
        let friend = addPlayerViewModel.friendList[indexPath.row]
        let bStatus = checkButtonStatus(id: friend.uid)
        
        cell.addPlayerTableViewCellDelegate = self
        cell.userNameLabel.text = friend.userName
        cell.userImageView.contentMode = .scaleToFill
        cell.addedButton.isEnabled = bStatus
        if bStatus {
            cell.addedButton.isEnabled = true
            cell.addedButton.setImage(UIImage(named: "Button_Add"), for: .normal)
        } else {
            cell.addedButton.isEnabled = false
            cell.addedButton.setImage(UIImage(named: "Button_added"), for: .normal)
        }
        cell.userImageView.layer.masksToBounds = true
        cell.userImageView.layer.cornerRadius = cell.userImageView.bounds.width / 2
        if let userImageURL = friend.userImageURL {
            cell.userImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL)
        }
        return cell
    }
    
    func checkButtonStatus(id: String) -> Bool {
        
        for player in addPlayerViewModel.playerList {
            if player.uid == id {
                return false
            }
        }
        return true
    }
}

// MARK: UICollectionViewDelegate
extension AddPlayerViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if addPlayerViewModel.playerList.count >= 1 {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        return addPlayerViewModel.playerList.count
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
    
    func didFinishCheckInvitation() {
        if self.addPlayerViewModel.cancelPlayer != "" {

            let playerName = self.addPlayerViewModel.cancelPlayer
            showAlert(title: "Can't choose this player" ,
                      message: "\(playerName) is already playing in the different team. Please choose other people.")
        } else {
        
            let alert = UIAlertController(title: "Send invitations",
                                          message: "Are you sure to send invitations?",
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Yes",
                                          style: .default,
                                          handler: { action in
                                                        self.prepareInvitation()
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func didFinishFetchData() {
        tableView.reloadData()
    }
}

// MARK: AddPlayerTableViewCellDelegate
extension AddPlayerViewController: AddPlayerTableViewCellDelegate {
    func didPressAdd(indexPath: IndexPath) {
        let player = addPlayerViewModel.friendList[indexPath.row]
        addPlayerViewModel.playerList.append(player)
        tableView.reloadRows(at: [indexPath], with: .none)
        collectionView.reloadData()
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
        
        collectionView.reloadData()
        tableView.reloadData()
    }
}

// MARK: DZNEmptyDataSetDelegate
extension AddPlayerViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Make some friends first"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "You don't have any friends. Go back to Menu and add some friends first."
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}
