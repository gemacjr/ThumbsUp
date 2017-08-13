//
//  LoginVC.swift
//  Thumbup
//
//  Created by Ed McCormic on 7/19/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate, Alertable {
    
    @IBOutlet weak var emailField: RoundedCornerTextField!
    @IBOutlet weak var passwordField: RoundedCornerTextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var authBtn: RoundedShadowButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self

        view.bindtoKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    func handleScreenTap(sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }

    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func authBtnWasPressed(_ sender: Any) {
        
        if emailField.text != nil && passwordField.text != nil {
            authBtn.animateButton(shouldLoad: true, withMessage: nil)
            self.view.endEditing(true)
            
            if let email = emailField.text, let password = passwordField.text {
                Firebase.Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error == nil {
                    if let user = user {
                        if self.segmentedControl.selectedSegmentIndex == 0 {
                            let userData = ["provider": user.providerID] as [String: Any]
                            DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: false)
                        } else {
                            
                            let userData = ["provider": user.providerID, "userIsDriver": true, "isPickupModeisEnabled": false, "driverIsOnTrip": false] as [String: Any]
                            DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                        }
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                    } else {
                        
                        if let errorCode = Firebase.AuthErrorCode(rawValue: error!._code){
                            switch errorCode {
                            case .wrongPassword:
                                self.showAlert("Whoops! That was the wrong password!")
                                
                            default:
                                self.showAlert("An unexpected err occured. Please try agian")
                            }
                        }
                        
                        
                        
                        Firebase.Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            
                            if error != nil {
                                if let errorCode = Firebase.AuthErrorCode(rawValue: error!._code){
                                switch errorCode {
                                case .invalidEmail:
                                    self.showAlert("Email invalid, please try again")
                                default:
                                    self.showAlert("An unexpected err occured. Please try agian")
                                }
                                    if errorCode == Firebase.AuthErrorCode.invalidEmail {
                                        self.showAlert("Email invalid, please try again")
                                    }
                                    
                            }
                            } else {
                                
                                if let user = user {
                                    if self.segmentedControl.selectedSegmentIndex == 0 {
                                        let userData = ["provider": user.providerID] as [String: Any]
                                        DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: false)
                                    } else {
                                        let userData = ["provider": user.providerID, "userIsDriver": true, "isPickupModeisEnabled": false, "driverIsOnTrip": false] as [String: Any]
                                        DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                                    }
                                }
                                
                                
                            }
                            self.dismiss(animated: true, completion: nil)
                            
                        })
                        self.dismiss(animated: true, completion: nil)
                    }
                
                })
            }
        }
    }
    
}
