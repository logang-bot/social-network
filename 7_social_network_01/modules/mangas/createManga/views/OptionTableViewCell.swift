//
//  OptionTableViewCell.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 21/7/22.
//

import UIKit

class OptionTableViewCell: UITableViewCell {
    
    static let identifier = "OptionCell"
    static let nibName = "OptionTableViewCell"

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var optionStatus: UIImageView!
    
    var firebaseManager = FirebaseManager.shared
    var status = false
    let checkedImage = UIImage(named: "ic_check_box")! as UIImage
    let uncheckedImage = UIImage(named: "ic_check_box_outline_blank")! as UIImage
    
    override func awakeFromNib() {
        super.awakeFromNib()
        optionStatus.image = uncheckedImage
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @discardableResult
    func toggleStatus() -> String {
        status = !status
        optionStatus.image = status ? checkedImage : uncheckedImage
        if status {
            return optionLabel.text!
        } else {
            return optionLabel.text!
        }
    }
    
    func setUpData(option: Category) {
        optionLabel.text = option.name
    }
}
