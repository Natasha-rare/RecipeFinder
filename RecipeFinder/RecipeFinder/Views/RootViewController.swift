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
        
        let recipeNames = defaults.stringArray(forKey: "recipeNames")
        let recipeUrls = defaults.stringArray(forKey: "recipeUrls")
        let recipeImages = defaults.stringArray(forKey: "recipeImages")
        
        if recipeUrls != nil
        {
            for i in 0..<recipeUrls!.count
            {
                fullLinks.append(Links(url: recipeUrls![i], imageUrl: recipeImages![i], name: recipeNames![i]))
            }
            print(fullLinks)
        }
        
        groceryIngridients = defaults.array(forKey: "grocery") as? [String] ?? [""]
        let homeVC = HomeController()
        let savedVC = SavedController()
        savedVC.refresh()
        let profileVC = ProfileController()
        let groceryVC = GroceryController()
        groceryVC.refresh()
        
            profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person.crop.circle"), tag: 0)
            homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 0)
            savedVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "bookmark"), tag: 0)
            groceryVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "cart"), tag: 0)
        
        let viewControllerList = [homeVC, groceryVC, savedVC, profileVC]
        
        viewControllers = viewControllerList
        
        tabBar.barTintColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        tabBar.isTranslucent = true
        tabBar.tintColor = UIColor(red: 0.847, green: 0.553, blue: 0.039, alpha: 1)
        tabBar.unselectedItemTintColor = .lightGray
    }
}
