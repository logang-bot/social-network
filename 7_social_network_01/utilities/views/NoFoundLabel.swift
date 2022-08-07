//
//  NoFoundLabel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 2/8/22.
//

import Foundation
import UIKit

class NoFoundLabel: UILabel {
    var parent: UIViewController
    init(parent: UIViewController) {
        self.parent = parent
        super.init(frame: .null)
        setupLabel()
    }
    
    func setupLabel() {
        let margins = parent.view.layoutMarginsGuide
        parent.view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: margins.topAnchor, constant: 120).isActive = true
        self.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -120).isActive = true
        self.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor, constant: 30).isActive = true
        self.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor, constant: -30).isActive = true
        self.textAlignment = NSTextAlignment.center
        self.text = "No results found"
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
