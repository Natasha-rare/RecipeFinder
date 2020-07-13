//
//  GroceryController.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/13/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit

class GroceryController: UIViewController{
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Grocery"
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        
        super.view.addSubview(label)
    }
}
