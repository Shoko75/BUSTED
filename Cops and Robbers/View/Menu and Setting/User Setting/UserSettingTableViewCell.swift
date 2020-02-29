//
//  UserSettingTableViewCell.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-02-14.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class UserSettingTableViewCell: UITableViewCell {

    // MARK: Properties
    var sectionType: SectionType? {
        didSet {
            guard let sectionType = sectionType else { return }
            textLabel?.text = sectionType.description
            switchControl.isHidden = !sectionType.containsSwitch
        }
    }
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.onTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        return switchControl
    }()
    
    // MARK: Init
    override func awakeFromNib() {
        super.awakeFromNib()
    
        addSubview(switchControl)
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @objc func handleSwitchAction(sender: UISwitch) {
        if sender.isOn {
            print("Turn on")
        } else {
            print("Turn off")
        }
    }
}
