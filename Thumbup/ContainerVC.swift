//
//  ContainerVC.swift
//  Thumbup
//
//  Created by Ed McCormic on 7/18/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case collpased
    case leftPanelExpanded
}

enum ShowWhichVC {
    case homeVC
}

var showVC: ShowWhichVC = .homeVC

class ContainerVC: UIViewController {
    
    var homeVC: HomeVC!
    var currentState: SlideOutState = .collpased {
        
        didSet {
            let shouldShowShadow = (currentState != .collpased)
            
            shouldShowShadowForCenterViewController(status: shouldShowShadow)
        }
    }
    var leftVC: LeftSidePanelVC!
    var centerController: UIViewController!
    var isHidden = false
    let centerPanelExpandedOffset: CGFloat = 160
    
    var tap: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        initCenter(screen: showVC)
        
    }
    
    
    func initCenter(screen: ShowWhichVC){
        var presentingController: UIViewController
        
        showVC = screen
        
        if homeVC == nil {
            homeVC = UIStoryboard.homeVC()
            homeVC.delegate = self
        }
        
        presentingController = homeVC
        
        if let con = centerController {
            con.view.removeFromSuperview()
            con.removeFromParentViewController()
        }
        centerController = presentingController
        
        view.addSubview(centerController.view)
        addChildViewController(centerController)
        centerController.didMove(toParentViewController: self)
        
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    override var prefersStatusBarHidden: Bool{
        return isHidden
    }

}

extension ContainerVC: CenterVCDelegate {
    
    
    func toggleLeftPanel(){
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
        
        
    }
    
    
    func addLeftPanelViewController(){
        
        if leftVC == nil {
            leftVC = UIStoryboard.leftViewController()
            addChildSidePanelViewController(leftVC!)
        }
        
        
    }
    
    func addChildSidePanelViewController(_ sidePanelController: LeftSidePanelVC) {
        
        view.insertSubview(sidePanelController.view, at: 0)
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
    }
    
    
    func animateLeftPanel(shouldExpand: Bool){
        
        if shouldExpand {
            isHidden = !isHidden
            animateStatusBar()
            
            setupWhiteCoverView()
            
            currentState = .leftPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: centerController.view.frame.width - centerPanelExpandedOffset)
            
        } else {
            isHidden = !isHidden
            animateStatusBar()
            
            hideWhiteCoverView()
            
            animateCenterPanelXPosition(targetPosition: 0, completion: { (finished) in
                
                if finished == true {
                    self.currentState = .collpased
                    self.leftVC = nil
                }
            })
        }
        
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations:{
            self.centerController.view.frame.origin.x = targetPosition
            
        }, completion: completion)
        
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations:{
            self.setNeedsStatusBarAppearanceUpdate()
            
        })
        
    }
    
    func setupWhiteCoverView() {
        
        let whiteCoverView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        whiteCoverView.alpha = 0.0
        whiteCoverView.backgroundColor = UIColor.white
        whiteCoverView.tag = 25
        
        self.centerController.view.addSubview(whiteCoverView)
        
        whiteCoverView.fadeTo(alphaValue: 0.75, withDuration: 0.2)
        
//        UIView.animate(withDuration: 0.2) {
//            whiteCoverView.alpha = 0.75
//        }
        
        tap = UITapGestureRecognizer(target: self, action: #selector(animateLeftPanel(shouldExpand:)))
        tap.numberOfTouchesRequired = 1
        
        self.centerController.view.addGestureRecognizer(tap)
        
        
    }
    
    func hideWhiteCoverView() {
        
        centerController.view.removeGestureRecognizer(tap)
        for subview in self.centerController.view.subviews {
            
            if subview.tag == 25 {
                
                UIView.animate(withDuration: 0.2, animations: { 
                }, completion: { (finished) in
                    subview.removeFromSuperview()
                })
            }
        }
        
    }
    
    func shouldShowShadowForCenterViewController(status: Bool) {
        
        if status == true {
            centerController.view.layer.shadowOpacity = 0.6
        } else {
            centerController.view.layer.shadowOpacity = 0.0
        }
    }
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    class func leftViewController() -> LeftSidePanelVC? {
        return mainStoryboard().instantiateViewController(withIdentifier: "LeftSidePanelVC") as? LeftSidePanelVC
        
    }
    
    class func homeVC() -> HomeVC? {
        return mainStoryboard().instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
    }
}
