//
//  EndGameViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-02-21.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

protocol EndGameDelegate {
    func backToMenu()
}

class EndGameViewController: UIViewController {

    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    
    var winCopsFlg: Bool?
    var endGameDelegate: EndGameDelegate!
    var endGameViewModel: EndGameViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initLayoutSetting()
        endGameViewModel = EndGameViewModel()
        endGameViewModel.updateUserInfo()
        
    }
    
    func initLayoutSetting() {
        menuButton.layer.cornerRadius = 12
        
        if let winCopsFlg = winCopsFlg {
            if winCopsFlg {
                backgroundImageView.image = UIImage(named: "End_game_modal_cops_bg")
                titleLabel.text = "TEAM COPS WIN!"
                detailLabel.text = "ALL ROBBERS HAVE BEEN APPREHENDED"
            } else {
                backgroundImageView.image = UIImage(named: "End_game_modal_robbers_bg")
                titleLabel.text = "TEAM ROBBERS WIN!"
                detailLabel.text = "ALL FLAGS HAVE BEEN CAPTURED"
            }
        }
    }
    
    @IBAction func pressedMenu(_ sender: Any) {
        self.dismiss(animated: false) {
            self.endGameDelegate.backToMenu()
        }
    }
    
}
