//
//  SignUpViewController.swift
//  pin
//
//  Created by Sarah Zhou on 7/9/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var logo = UIImageView()
    var usernameField = UITextField()
    var passwordField = UITextField()
    var confirmPasswordField = UITextField()
    var loginButton = UIButton()
    var signUpButton = UIButton()
    var invalidLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpView() {
        view.backgroundColor = UIColor.whiteColor()
        
        logo.frame = CGRect(x: 148, y: 95, width: 80, height: 80)
        usernameField.frame = CGRect(x: 25, y: 220, width: 320, height: 30)
        passwordField.frame = CGRect(x: 25, y: 320, width: 320, height: 30)
        confirmPasswordField.frame = CGRect(x: 25, y: 370, width: 320, height: 30)
        
        invalidLabel.frame = CGRect(x: 0, y: 420, width: 375, height: 40)
        
        loginButton.frame = CGRect(x: 35, y: 567, width: 300, height: 30)
        signUpButton.frame = CGRect(x: 0, y: 607, width: 375, height: 60)
        
        logo.image = UIImage(named: "logo")
        
        usernameField.placeholder = "USERNAME"
        passwordField.placeholder = "PASSWORD"
        confirmPasswordField.placeholder = "CONFIRM PASSWORD"
        passwordField.secureTextEntry = true
        confirmPasswordField.secureTextEntry = true
        
        usernameField.font = usernameField.font?.fontWithSize(16.0)
        passwordField.font = passwordField.font?.fontWithSize(16.0)
        confirmPasswordField.font = confirmPasswordField.font?.fontWithSize(16.0)
        
        usernameField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        signUpButton.backgroundColor = UIColor.cyan()
        signUpButton.setTitle("SIGNUP", forState: UIControlState.Normal)
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        loginButton.setTitle("Already have an account? Login!", forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.darkGray(), forState: UIControlState.Normal)
        
        invalidLabel.text = "Email address already has an existing account"
        invalidLabel.backgroundColor = UIColor.deepOrange()
        invalidLabel.textColor = UIColor.whiteColor()
        invalidLabel.textAlignment = NSTextAlignment.Center
        invalidLabel.hidden = true
        
        signUpButton.addTarget(self, action: #selector(signUpClicked), forControlEvents: UIControlEvents.TouchUpInside)
        loginButton.addTarget(self, action: #selector(loginClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(logo)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(confirmPasswordField)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        view.addSubview(invalidLabel)
    }
    
    func signUpClicked() {
        
        if usernameField.text == "" {
            invalidLabel.text = "Username is required"
            invalidLabel.hidden = false
        } else if passwordField.text == "" {
            invalidLabel.text = "Password is required"
            invalidLabel.hidden = false
        } else if confirmPasswordField.text == "" {
            invalidLabel.text = "Please confirm password"
            invalidLabel.hidden = false
        } else if passwordField.text != confirmPasswordField.text {
            invalidLabel.text = "Passwords do not match"
            invalidLabel.hidden = false
        } else {
            // initialize a user object
            let newUser = PFUser()
            
            // set user properties
            newUser.username = usernameField.text
            newUser.password = passwordField.text
            
            // call sign up function on the object
            newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if success {
                    print("Created a user")
                    self.setupTabBarController()
                } else {
                    print(error?.localizedDescription)
                    if error?.code == 202 {
                        self.invalidLabel.text = "Username is already taken"
                        self.invalidLabel.hidden = false
                    } else if error?.code == 203 {
                        self.invalidLabel.text = "Email is already taken"
                        self.invalidLabel.hidden = false
                    }
                }
            }
        }
    }
    
    func setupTabBarController() {
        let tabBar = UITabBarController()
        
        let search = SearchViewController()
        let map = MapViewController()
        let profile = ProfileViewController()
        
        search.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 0)
        map.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "map"), tag: 1)
        profile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), tag: 4)
        
        let vcs = [search, map, profile]
        tabBar.viewControllers = vcs
        tabBar.modalPresentationStyle = .FullScreen
        tabBar.modalTransitionStyle = .CoverVertical
        self.presentViewController(tabBar, animated: true, completion: nil)
    }

    
    func loginClicked() {
        let vc = LoginViewController()
        vc.modalPresentationStyle = .FullScreen
        vc.modalTransitionStyle = .CoverVertical
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
