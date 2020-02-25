//
//  TermsOfUseViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-02-24.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit
import WebKit

class ContractViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    private let TC_URL = URL(string: "https://shoko75.github.io/BUSTED-document/terms_and_conditions.html")
    private let PRIVACY_URL = URL(string: "https://shoko75.github.io/BUSTED-document/privacy_policy.html")
    
    var pageNum:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let about = AboutOptions(rawValue: pageNum!)
        switch about {
        case .termsAndConditions:
            let request = URLRequest(url: TC_URL!)
            webView.load(request)
        case .privacyPolicy:
            let request = URLRequest(url: PRIVACY_URL!)
            webView.load(request)
        default: return
        }
    }

    @IBAction func pressedDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
