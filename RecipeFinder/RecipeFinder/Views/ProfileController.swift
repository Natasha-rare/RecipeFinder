//
//  ProfileController.swift
//  RecipeFinder
//
//  Created by I on 10.07.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class ProfileController: UIViewController{
    var buttonExit = NeoButton()
    let label = UILabel()
    var name = UILabel()
    var email = UILabel()
    var password = UILabel()
    var greeting = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Profile"
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        
        let image = UIImage(named: "user-1.png")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 128, y: 139, width: 117, height: 117)
        
        greeting.frame = CGRect(x: 61, y: 281, width: 257, height: 58)
        greeting.font = UIFont(name: "Harmattan-Regular", size: 24)
        greeting.textColor = UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1)
        greeting.textAlignment = .center
        
        email.frame = CGRect(x: 61, y: 348, width: 257, height: 58)
        email.font = UIFont(name: "Harmattan-Regular", size: 24)
        email.textColor = UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1)
        email.textAlignment = .center
        
        buttonExit.load(title: "log out", frame: CGRect(x: 58, y: 589, width: 259, height: 58))
        buttonExit.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        
        super.view.addSubview(label)
        super.view.addSubview(buttonExit)
        super.view.addSubview(imageView)
        super.view.addSubview(greeting)
        super.view.addSubview(email)
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
