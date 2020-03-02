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
    
    private var endGameViewModel = EndGameViewModel()
    var winCopsFlg: Bool?
    var endGameDelegate: EndGameDelegate!
    
    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutSetting()
        endGameViewModel.updateUserInfo()
    }
    
    func layoutSetting() {
        menuButton.layer.cornerRadius = 12
        
        if let winCopsFlg = winCopsFlg {
            if winCopsFlg {
                backgroundImageView.image = R.image.wallpaper.endGameCops()
                titleLabel.text = "TEAM COPS WIN!"
                detailLabel.text = "ALL ROBBERS HAVE BEEN APPREHENDED"
            } else {
                backgroundImageView.image = R.image.wallpaper.endGameRobbers()
                titleLabel.text = "TEAM ROBBERS WIN!"
                detailLabel.text = "ALL FLAGS HAVE BEEN CAPTURED"
            }
        }
    }
    
    // MARK: Button Functions
    @IBAction func pressedMenu(_ sender: Any) {
        self.dismiss(animated: false) {
            self.endGameDelegate.backToMenu()
        }
    }
}
