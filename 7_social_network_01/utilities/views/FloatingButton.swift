//
//  FloatingButton.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 17/7/22.
//

import Foundation
import UIKit

class FloatingButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.widthAnchor.constraint(equalToConstant: 56).isActive = true
        self.heightAnchor.constraint(equalToConstant: 56).isActive = true
        self.layer.cornerRadius = 28
        self.setImage(UIImage(systemName: "plus"), for: .normal)
//        self.backgroundColor = UIColor(red: 1/255, green: 70/255, blue: 175/255, alpha: 1)
        
        self.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        self.setTitle("", for: .normal)
        
        self.tintColor = .white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3.0
    }
}
