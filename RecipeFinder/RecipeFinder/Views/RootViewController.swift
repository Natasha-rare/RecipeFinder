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
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: ""), tag: 0)
        savedVC.tabBarItem = UITabBarItem(title: "Saved", image: UIImage(named: ""), tag: 0)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: ""), tag: 0)
        let viewControllerList = [homeVC, savedVC, profileVC]
        viewControllers = viewControllerList
        // tab bar and etc
    }
}
