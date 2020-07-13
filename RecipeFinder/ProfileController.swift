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
    var buttonExit = NeoButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let label = UILabel()
        
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Profile"
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        super.view.addSubview(label)
        
        buttonExit.load(title: "log out", frame: CGRect(x: 58, y: 589, width: 259, height: 58))
        buttonExit.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        
        super.view.addSubview(buttonExit)
    }
    @objc func buttonClicked(sender: UIButton){
        
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "logged")
        
        let vc = ViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        print("Button1 Clicked")
    }
}
