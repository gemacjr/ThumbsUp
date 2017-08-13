//
//  CenterVCDelegate.swift
//  Thumbup
//
//  Created by Ed McCormic on 7/18/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import UIKit

protocol CenterVCDelegate {
    func toggleLeftPanel()
    func addLeftPanelViewController()
    func animateLeftPanel(shouldExpand: Bool)
}
