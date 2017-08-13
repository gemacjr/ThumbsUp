//
//  RoundedShadowView.swift
//  Thumbup
//
//  Created by Ed McCormic on 7/18/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import UIKit

class RoundedShadowView: UIView {
    
    override func awakeFromNib() {
        
        setupView()
    }

    func setupView() {
        
        self.layer.cornerRadius = 5.0
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        
    }

}
