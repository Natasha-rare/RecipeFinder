//
//  ProfileController.swift
//  RecipeFinder
//
//  Created by I on 10.07.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit
class ProfileController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect(x: 3, y: 85, width: 370, height: 53)
        label.textColor = UIColor.black
        label.text = "Your profile"
        label.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        label.textAlignment = .center
        super.view.addSubview(label)
    }
}
