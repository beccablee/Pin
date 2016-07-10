//
//  ProfileViewController.swift
//  pin
//
//  Created by Sarah Zhou on 7/9/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var imageView = PFImageView()
    var nameLabel = UILabel()
    var usernameLabel = UILabel()
    var bioLabel = UILabel()
    var tablePins = UITableView()
    var cell = PinCell()
    var editButton = UIButton()
    
    
    var posts = [PFObject]()
    var post: PFObject!
    
    
    let cellReuseIdendifier = "pinCell"
    
    var user : User?
    
    let data = ["Pin1, Description1", "Pin2, Description2", "Pin3, Description3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = User.currentUser()
        self.navigationController?.navigationBarHidden = true
        
        fetchPins { (success: Bool, error: NSError?) in
            print(self.posts)
        }
        
        setUpViews()
        loadData()
    }
    
    func viewDidAppear() {
        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchPins { (success: Bool, error: NSError?) in
            print(self.posts)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpViews(){
        
        view.backgroundColor = UIColor.whiteColor()

        imageView.frame = CGRect(x: 123, y: 20, width: 128, height: 128)
        imageView.image = UIImage (named:"logo")
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        nameLabel.frame = CGRect(x: 0, y: 156, width: 375, height: 21)
        nameLabel.textAlignment = NSTextAlignment.Center
        usernameLabel.frame = CGRect(x: 0, y: 178, width: 375, height: 21)
        usernameLabel.textColor = UIColor.grayColor()
        usernameLabel.textAlignment = NSTextAlignment.Center
        
        bioLabel.frame = CGRect(x: 0, y: 198, width: 375, height: 21)
        bioLabel.textColor = UIColor.grayColor()
        bioLabel.textAlignment = NSTextAlignment.Center
        
        tablePins.frame = CGRect(x: 0, y: 220, width: 375, height: 460)
        tablePins.delegate = self
        tablePins.dataSource = self
        tablePins.registerClass(PinCell.self, forCellReuseIdentifier: "pinCell")
        tablePins.rowHeight = 94
        
        editButton.frame = CGRect(x: 335, y: 22, width: 30, height: 30)
        editButton.setImage(UIImage(named: "settings"), forState: .Normal)
        editButton.addTarget(self, action: #selector(editProfile), forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(usernameLabel)
        view.addSubview(bioLabel)
        view.addSubview(tablePins)
        view.addSubview(editButton)
    }
    
    func loadData() {
        
        if user!["profilePic"] != nil {
            imageView.file = user!["profilePic"] as! PFFile
        } else {
            imageView.image = UIImage(named: "defaultProfilePic")
        }
        if user!["name"] != nil {
            nameLabel.text = user!["name"] as! String
        }
        usernameLabel.text = "@\(user!["username"] as! String)"
        usernameLabel.textColor = UIColor.lightGrayColor()
        if user!["bio"] != nil {
            bioLabel.text = user!["bio"] as! String
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pinCell", forIndexPath: indexPath) as! PinCell
        if posts.count != 0 {
            let post = posts[indexPath.row] as! PFObject
            print("displaying post")
            print(post)
            
            cell.pinNameLabel.text = post["title"] as! String
            cell.descriptionLabel.text = post["description"] as! String
            
            let parsedImage = post["media"] as? PFFile
            cell.ivPin.file = parsedImage
            cell.ivPin.loadInBackground()
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowDetailVC", sender: nil)
    }
    
    
    func fetchPins(withCompletion completion: PFBooleanResultBlock?) {
        
        let pinQuery = PFQuery(className: "Pin")
        pinQuery.whereKey("author", equalTo: (PFUser.currentUser())!)
        //(user!.username)!
        //PFUser.currentUser()
        pinQuery.findObjectsInBackgroundWithBlock {
            (posts: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successful query for pins")
                
                if let posts = posts {
                    self.posts = posts
                    print(posts)

                    self.tablePins.reloadData()
                }
                else {
                    print(error?.localizedDescription)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tablePins.reloadData()
                })
                
            }
            else {
                // Log details of the failure
                print("Error: \(error)")
            }
        }
    }

    
    
    
    func editProfile() {
        // self.presentViewController(self.navigationVC, animated: true, completion: nil)
        let vc = ProfileSettingsViewController()
        vc.modalPresentationStyle = .FullScreen
        vc.modalTransitionStyle = .CoverVertical
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailViewController" {
            let button = sender as! UIButton
            let contentView = button.superview! as UIView
            let cell = contentView.superview as! PinCell
            let indexPath = tablePins.indexPathForCell(cell)
            let pin = data[indexPath!.row]
            
            //let detailViewController = segue.destinationViewController as! DetailViewController
            //detailViewController = pin
        }
    }*/
    
}








