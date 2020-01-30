//
//  LoadGameViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-29.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class LoadGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            self.performSegue(withIdentifier: "showMap", sender: nil)
        }
    }
}
