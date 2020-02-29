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

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var userSettingViewModel: UserSettingViewModel!
    
    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutSetting()
        
        userSettingViewModel = UserSettingViewModel()
        userSettingViewModel.userSettingDelegate = self
        userSettingViewModel.observeUserInfo()
    }
    
    func layoutSetting() {
        userImageView.contentMode = .scaleToFill
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
        tableView.separatorColor = UIColor.clear
    }
    
    // MARK: Others
    func setUserInfo() {
        if let userImage = userSettingViewModel.userInfo?.userImageURL {
            userImageView.loadImageUsingCacheWithUrlString(urlString: userImage)
        }
        userNameLabel.text = userSettingViewModel.userInfo?.userName
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.userSettingViewController.showContract.identifier {
            if let contractViewController = segue.destination as? ContractViewController {
                if let rowNum = sender {
                    contractViewController.pageNum = rowNum as? Int
                }
            }
        }
    }
}

// MARK: UITableViewDelegate
extension UserSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return UserSettingSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = UserSettingSection(rawValue: section) else { return 0 }
        
        switch section {
            case .Account: return AccountOptions.allCases.count
            case .About: return AboutOptions.allCases.count
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
            case .About:
                let about = AboutOptions(rawValue: indexPath.row)
                cell.sectionType = about
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
                        userSettingViewModel.stopOberveUserInfo()
                        userSettingViewModel.deleteToken()
                        try Auth.auth().signOut()
                        let loginController = R.storyboard.login.instantiateInitialViewController()
                        self.view.window?.rootViewController = loginController
                        
                    } catch let error {
                        print("Faild to sign out with error: \(error)")
                    }
                case .changeProfilePicture:
                    print("changeProfilePicture")
                    self.showImagePickerController()
                case .none:
                    print("none")
                }
            case .About:
                self.performSegue(withIdentifier: R.segue.userSettingViewController.showContract, sender: indexPath.row)
        }
    }
}

// MARK: UserSettingDelegate
extension UserSettingViewController: UserSettingDelegate {
    func didFinishObserveUserInfo() {
        self.setUserInfo()
    }
}

// MARK: UIImagePickerControllerDelegate (For Photo Library)
extension UserSettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerController() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImageView.image = originalImage
        }
        
        dismiss(animated: true, completion: {
            self.userSettingViewModel.changeUserImage(userImage: self.userImageView.image!)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
}
