//
//  RootViewController.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/9/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import  UIKit
class RootViewController: UITabBarController{

    override func viewDidLoad() {
        
        super.viewDidLoad()
        let homeVC = HomeController()
        let savedVC = SavedController()
        let profileVC = ProfileController()
        let groceryVC = GroceryController()
        profileVC.FetchUserData()
        homeVC.getRecipes()
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "home.png"), tag: 0)
        savedVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "post.png"), tag: 0)
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "user.png"), tag: 0)
        groceryVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "shopping-cart"), tag: 0)
        let viewControllerList = [groceryVC, homeVC, savedVC, profileVC]
        viewControllers = viewControllerList
        tabBar.barTintColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        tabBar.isTranslucent = true
        
        tabBar.tintColor = UIColor(red: 0.847, green: 0.553, blue: 0.039, alpha: 1)
        tabBar.unselectedItemTintColor = .lightGray
        // tab bar and etc
    }
}
