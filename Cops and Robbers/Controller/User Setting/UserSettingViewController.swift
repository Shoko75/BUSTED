//
//  UserSettingViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-02-14.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit
import Firebase

class UserSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}

extension UserSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return UserSettingSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = UserSettingSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Account: return AccountOptions.allCases.count
        case .Settings: return SettingsOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 23/255, green: 23/255, blue: 49/255, alpha: 1)
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = UserSettingSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSettingTableViewCell", for: indexPath) as! UserSettingTableViewCell
        
        guard let section = UserSettingSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        cell.textLabel?.textColor = UIColor.white
        switch section {
        case .Account:
            let account = AccountOptions(rawValue: indexPath.row)
            cell.sectionType = account
        case .Settings:
            let settings = SettingsOptions(rawValue: indexPath.row)
            cell.sectionType = settings
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = UserSettingSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .Account:
            let account = AccountOptions(rawValue: indexPath.row)
            switch account {
            case .logout:
                print("logout")
                do {
                    try Auth.auth().signOut()
                    let storybord = UIStoryboard(name: "Login", bundle: nil)
                    let loginController = storybord.instantiateViewController(identifier: "Login") as! LoginViewController
                    self.view.window?.rootViewController = loginController
                    
                } catch let error {
                    print("Faild to sign out with error: \(error)")
                }
            case .changePassword:
                print("changePassword")
            case .none:
                print("none")
            }
        case .Settings:
            let settings = SettingsOptions(rawValue: indexPath.row)?.description
            print(settings)
            
        }
    }
    
    
}
