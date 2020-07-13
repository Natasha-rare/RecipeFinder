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
        view.backgroundColor = .white
        
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Profile"
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        
        let image = UIImage(named: "user.png")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 128, y: 139, width: 117, height: 117)
        
        greeting.frame = CGRect(x: 0, y: 280, width: 400, height: 50)
        greeting.font = UIFont(name: "Roboto", size: 30)
        greeting.textAlignment = .center
        
        email.frame = CGRect(x: 0, y: 300, width: 400, height: 50)
        greeting.font = UIFont(name: "Roboto", size: 30)
        greeting.textAlignment = .center
        
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
