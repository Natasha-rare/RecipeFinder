//
//  RootViewController.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/9/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import  UIKit
import Purchases
class RootViewController: UITabBarController{
    let userNotificationCenter = UNUserNotificationCenter.current()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestNotificationAuthorization()
        self.sendNotification()
        let recipeNames = defaults.stringArray(forKey: "recipeNames")
        let recipeUrls = defaults.stringArray(forKey: "recipeUrls")
        let recipeImages = defaults.stringArray(forKey: "recipeImages")
        
        if recipeUrls != nil
        {
            for i in 0..<recipeUrls!.count
            {
                fullLinks.append(Links(url: recipeUrls![i], imageUrl: recipeImages![i], name: recipeNames![i]))
            }
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
    
    override func viewDidAppear(_ animated: Bool) {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if purchaserInfo?.entitlements["Chef version"]?.isActive != true{
                print("USER IS NOT PREMIUM")
                let vc  = PayWallController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            else{
                print("USER IS PREMIUM")
            }
        }
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }

    func sendNotification() {
        
        let name = defaults.string(forKey: "name")
        let bodies = [
            "A typical ear of corn has an even number of rows.",
            "Scientists can turn peanut butter into diamonds.",
            "One burger patty can contain hundreds of different cows.",
            "Raspberries are a member of the rose family.",
            "Fruit snacks and cars are coated in the same type of wax.",
            "Ripe cranberries will bounce like rubber balls.",
            "An 11-year-old invented the Popsicle by accident.",
            "Farm-raised salmon is naturally white and then dyed pink.",
            "Apple pie is not American, it was invented in Medieval England.",
            "Potatoes can absorb and reflect Wi-fi signals.",
            "The red food dye used in Skittles is made from boiled beetles.",
            "Raw oysters are still alive when you eat them.",
            "Every banana you eat is a clone of the Cavendish variety.",
            "Bananas are technically berries",
            "Before being domesticated, chickens only produced about a dozen eggs a year. Now they can produce hundreds.",
            "The Aztecs used chocolate as currency.",
            "Honey will never ever go bad.",
            "Carrots were originally purple (according to the National Carrot Museum in the UK).",
            "Most wasabi is actually just dyed horseradish.",
            "People once thought tomatoes were poisonous.",
            "Grapes will explode if you put them in the microwave.",
            "Eating too much nutmeg has the effect of a hallucinogenic drug.",
            "Processed cheese was invented in Switzerland, not America."
            
        ]
        
        
        let titles = ["Fact for you", "Fun food fact", "Did you know?", "Food fact of the week", "Dear \(name ?? "Chef")! Weekly food fact for you", "Do you know?", "Hey! Did you know?", "Food fact", "Cool fact", "This may be interesting", "Isn't that amazing?!"]
        let content = UNMutableNotificationContent()
        content.body = bodies.randomElement()!
        content.title = titles.randomElement()!
        content.sound = UNNotificationSound.default
        content.badge = 0
        
        var date = DateComponents()
        date.weekday = 7
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "cooking",
                                            content: content,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
