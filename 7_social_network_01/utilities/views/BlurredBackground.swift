//
//  BlurredBackground.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 31/7/22.
//

import UIKit

class BlurredBackground: UIVisualEffectView {

    init(parent: UIViewController) {
        super.init(effect: nil)
        self.effect = UIBlurEffect(style: .systemMaterialLight)
        parent.view.addSubview(self)
      
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: parent.view.topAnchor, constant: 0.0).isActive = true
        self.bottomAnchor.constraint(equalTo: parent.view.bottomAnchor, constant: 0.0).isActive = true
        self.leftAnchor.constraint(equalTo: parent.view.leftAnchor, constant: 0.0).isActive = true
        self.rightAnchor.constraint(equalTo: parent.view.rightAnchor, constant: 0.0).isActive = true

        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
