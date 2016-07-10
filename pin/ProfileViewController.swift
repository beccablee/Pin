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
    var nameLabelStr: String = ""
    var descriptionLabelStr: String = ""
    var selectedLocation: CLLocationCoordinate2D!
    var pinImageFromCell: UIImage!
    
    
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
        self.navigationController?.navigationBarHidden = true

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true

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

        imageView.frame = CGRect(x: 123, y: 65, width: 128, height: 128)
        imageView.image = UIImage(named: "logo")
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        nameLabel.frame = CGRect(x: 0, y: 201, width: 375, height: 21)
        nameLabel.textAlignment = NSTextAlignment.Center
        usernameLabel.frame = CGRect(x: 0, y: 223, width: 375, height: 21)
        usernameLabel.textColor = UIColor.grayColor()
        usernameLabel.textAlignment = NSTextAlignment.Center
        
        bioLabel.frame = CGRect(x: 0, y: 243, width: 375, height: 21)
        bioLabel.textColor = UIColor.grayColor()
        bioLabel.textAlignment = NSTextAlignment.Center
        
        tablePins.frame = CGRect(x: 0, y: 265, width: 375, height: 350)
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
          //  imageView.loadInBackground()
            
        } else {
            imageView.image = UIImage(named: "logo")
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
            let point = post["location"] as! PFGeoPoint
            cell.location = CLLocationCoordinate2DMake(point.latitude, point.longitude)
            
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
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!;
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! PinCell!;
        
        //grab all of the info from the cell
        if (currentCell.pinNameLabel.text != ""){
            nameLabelStr = currentCell.pinNameLabel.text!
        }
        if (currentCell.descriptionLabel.text != ""){
            descriptionLabelStr = currentCell.descriptionLabel.text!
        }
        
        selectedLocation = currentCell.location
        
        pinImageFromCell = currentCell.ivPin.image
    
        
        //call perform
        performSegueWithIdentifier("ShowDetailVC", sender: self)
        
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
                    self.posts = self.posts.reverse()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "ShowDetailVC") {
            
            // initialize new view controller and cast it as your view controller
            var viewController = segue.destinationViewController as! DetailViewController
            // your new view controller should have property that will store passed value
            viewController.pinLocation = selectedLocation
            viewController.titleStr = nameLabelStr
            viewController.descriptionStr = descriptionLabelStr
            viewController.imageFromCell = pinImageFromCell
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








