//
//  ProfileSettingsViewController.swift
//  pin
//
//  Created by Sarah Zhou on 7/9/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileSettingsViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate {
    
    var profilePic = PFImageView()
    var nameIcon = UIImageView()
    var usernameIcon = UIImageView()
    var bioIcon = UIImageView()
    var emailIcon = UIImageView()
    
    var privateInfoLabel = UILabel()
    var nameField = UITextField()
    var usernameField = UITextField()
    var bioField = UITextField()
    var emailField = UITextField()
    
    var changeProfPic = UIButton()
    var saveChanges = UIButton()
    var logout = UIButton()
    
    let imagePicker = UIImagePickerController()
    let user = User.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        loadInfo()
    }
    
    func setUpView() {
        
        view.backgroundColor = UIColor.whiteColor()
        
        profilePic.frame = CGRect(x: 112, y: 93, width: 150, height: 150)
        changeProfPic.frame = CGRect(x: 172, y: 251, width: 30, height: 12)
        nameField.frame = CGRect(x: 58, y: 281, width: 297, height: 30)
        usernameField.frame = CGRect(x: 58, y: 319, width: 297, height: 30)
        bioField.frame = CGRect(x: 58, y: 357, width: 297, height: 30)
        emailField.frame = CGRect(x: 58, y: 446, width: 297, height: 30)
        
        privateInfoLabel.frame = CGRect(x: 20, y: 417, width: 335, height: 21)
        nameIcon.frame = CGRect(x: 20, y: 281, width: 30, height: 30)
        usernameIcon.frame = CGRect(x: 20, y: 319, width: 30, height: 30)
        bioIcon.frame = CGRect(x: 20, y: 357, width: 30, height: 30)
        emailIcon.frame = CGRect(x: 20, y: 446, width: 30, height: 30)
        
        saveChanges.frame = CGRect(x: 20, y: 490, width: 335, height: 30)
        logout.frame = CGRect(x: 0, y: 617, width: 375, height: 50)
        
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        
        nameIcon.image = UIImage(named: "name")
        usernameIcon.image = UIImage(named: "username")
        bioIcon.image = UIImage(named: "bio")
        emailIcon.image = UIImage(named: "email")
        
        nameField.placeholder = "FULL NAME"
        usernameField.placeholder = "USERNAME"
        bioField.placeholder = "BIO"
        emailField.placeholder = "EMAIL ADDRESS"
        privateInfoLabel.text = "PRIVATE INFORMATION"
        
        saveChanges.setTitle("Save Changes", forState: .Normal)
        saveChanges.layer.borderWidth = 1.0
        saveChanges.layer.borderColor = UIColor.cyan().CGColor
        saveChanges.layer.cornerRadius = 10.0
        
        logout.backgroundColor = UIColor.deepOrange()
        logout.setTitle("LOGOUT", forState: .Normal)
        logout.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        nameField.font = usernameField.font?.fontWithSize(16.0)
        usernameField.font = usernameField.font?.fontWithSize(16.0)
        bioField.font = bioField.font?.fontWithSize(16.0)
        emailField.font = emailField.font?.fontWithSize(16.0)
        privateInfoLabel.font = privateInfoLabel.font?.fontWithSize(16.0)
        
        nameField.delegate = self
        usernameField.delegate = self
        bioField.delegate = self
        emailField.delegate = self
        
        nameField.autocapitalizationType = UITextAutocapitalizationType.None
        nameField.autocorrectionType = .No
        usernameField.autocapitalizationType = UITextAutocapitalizationType.None
        usernameField.autocorrectionType = .No
        bioField.autocapitalizationType = UITextAutocapitalizationType.None
        bioField.autocorrectionType = .No
        emailField.autocapitalizationType = UITextAutocapitalizationType.None
        emailField.autocorrectionType = .No
        
        changeProfPic.addTarget(self, action: #selector(changeProfPicClicked), forControlEvents: UIControlEvents.TouchUpInside)
        saveChanges.addTarget(self, action: #selector(saveChangesClicked), forControlEvents: UIControlEvents.TouchUpInside)
        logout.addTarget(self, action: #selector(logoutClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(profilePic)
        view.addSubview(changeProfPic)
        view.addSubview(nameIcon)
        view.addSubview(usernameIcon)
        view.addSubview(bioIcon)
        view.addSubview(emailIcon)
        
        view.addSubview(privateInfoLabel)
        view.addSubview(nameField)
        view.addSubview(usernameField)
        view.addSubview(bioField)
        view.addSubview(emailField)
    }
    
    func loadInfo() {
        if user?.profilePic != nil {
            profilePic.file = user?.profilePic
        } else {
            profilePic.image = UIImage(named: "defaultProfilePic")
        }
        
        nameField.text = user?.name
        usernameField.text = user?.username
        bioField.text = user?.bio
        emailField.text = user?.email
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeProfPicClicked() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let size = CGSize(width: 300.0, height: 300.0)
            let resizedImage = resize(pickedImage, newSize: size)
            
            profilePic.image = resizedImage
            let file = User.getPFFileFromImage(resizedImage)
            user?.profilePic = file
            user!.saveInBackground()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func saveChangesClicked() {
        user?.saveInBackground()
    }
    
    func logoutClicked() {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            let vc = WelcomeViewController()
            vc.modalPresentationStyle = .FullScreen
            vc.modalTransitionStyle = .CoverVertical
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
