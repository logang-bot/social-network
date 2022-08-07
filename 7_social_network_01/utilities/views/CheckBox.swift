//
//  CheckBox.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 21/7/22.
//

import UIKit

class CheckBox: UIImageView {
    // Images
    let checkedImage = UIImage(named: "ic_check_box")! as UIImage
    let uncheckedImage = UIImage(named: "ic_check_box_outline_blank")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.image = checkedImage
            } else {
                self.image = uncheckedImage
            }
        }
    }
        
    override func awakeFromNib() {
        self.isChecked = false
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}

