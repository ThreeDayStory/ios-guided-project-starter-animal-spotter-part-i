//
//  LoginViewController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!
    
    var apiController: APIController? // dependency injection - need to let the login viewer know which APIController instance to use
    var loginType = LoginType.signUp

    override func viewDidLoad() {
        super.viewDidLoad()

        // customize button appearance (background, tint, and corner radius)
        signInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1)
        signInButton.tintColor = .white
        signInButton.layer.cornerRadius = 8.0
    }
    
    // MARK: - Action Handlers
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        // perform login or sign up operation based on loginType
        guard let apiController = apiController else { return }
        
        if let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty {
            
            let user = User(username: username, password: password)
        
            // check state of type
            if loginType == .signUp {
                apiController.signUp(with: user) { error in // only one parameter needs no parentheses
                    if let error = error {
                        print("Error occured during sign up: \(error)")
                    } else {
                    // present alert and send to sign in page and make sure you're on the main thread
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful!",
                                                                    message: "Now please log in.", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: {
                                self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                                self.loginType = .signIn
                                self.signInButton.setTitle("Sign In", for: .normal)
                            })
                        }
                    }
                }
            } else {
                apiController.signIn(with: user) { error in
                    if let error = error {
                        print("Error occured during sign in: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        // switch UI between modes
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
}
