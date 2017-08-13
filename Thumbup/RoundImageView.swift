//
//  RoundImageView.swift
//  Thumbup
//
//  Created by Ed McCormic on 7/18/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {
    
    override func awakeFromNib() {
        
        setupView()
    }

    func setupView() {
        
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }

}
