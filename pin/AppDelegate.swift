//
//  AppDelegate.swift
//  pin
//
//  Created by Sarah Zhou on 7/9/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBar = UITabBarController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//       let navBarAppearance = UINavigationBar.appearance()
//        navBarAppearance.translucent = true
//        navBarAppearance.shadowImage = UIImage()
//        navBarAppearance.backgroundColor = UIColor.clearColor()
//
//        navBarAppearance.barTintColor = UIColor.clearColor()
//        navBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.clearColor()]
        

        
        // window?.rootViewController = WelcomeViewController()
        
//        
//        let search = SearchViewController()
//        let map = MapViewController()
//        let profile = ProfileViewController()
//        
//        let navigationController = UINavigationController(rootViewController: profile)
//
//        
//        search.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 0)
//        map.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "map"), tag: 1)
//        navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), tag: 2)
//        
//        let vcs = [search, map, navigationController]
//        tabBar.viewControllers = vcs
//        tabBar.selectedIndex = 1
//        tabBar.modalPresentationStyle = .FullScreen
//        tabBar.modalTransitionStyle = .CoverVertical
//
        User.registerSubclass()

        // Initialize Parse
        // Set applicationId and server based on the values in the Heroku settings.
        // clientKey is not used on Parse open source unless explicitly configured
        Parse.initializeWithConfiguration(
            ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "pin-hackfest"
                configuration.clientKey = "jaslj0q83thoa8sf0q293urjoaisnf0q283f"
                configuration.server = "http://pin-hackfest.herokuapp.com/parse"
            })
        )
//
//        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        self.window?.rootViewController = WelcomeViewController()
//        self.window?.makeKeyAndVisible()
//
        if let _ = PFUser.currentUser() {
//            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("tabBarID")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

