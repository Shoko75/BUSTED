//
//  AccountLoginViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-10.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import UIKit

class AccountLoginViewController: UIViewController {

    @IBOutlet weak var circleView: CustomUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout
        circleView.drawSemiCircle()
    }
}
