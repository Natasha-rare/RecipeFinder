//
//  RegistrationController.swift
//  RecipeFinder
//
//  Created by I on 10.07.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit
class RegistrationController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect(x: 3, y: 85, width: 370, height: 53)
        label.textColor = UIColor.black
        label.text = "Registration"
        label.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        label.textAlignment = .center
        super.view.addSubview(label)
        
        let login = UITextField()
        login.backgroundColor = .lightGray
        login.placeholder = "login"
        login.frame = CGRect(x: 47, y: 200, width: 200, height: 40)
        login.textColor = .white
        login.layer.cornerRadius = 15.0
        login.layer.borderWidth = 2.0
        login.layer.borderColor = UIColor.lightGray.cgColor
        
        let password = UITextField()
        password.backgroundColor = .lightGray
        password.placeholder = "password"
        password.frame = CGRect(x: 47, y: 250, width: 272, height: 40)
        password.textColor = .white
        password.layer.cornerRadius = 15.0
        password.layer.borderWidth = 2.0
        password.layer.borderColor = UIColor.lightGray.cgColor
        
        let confirm = UITextField()
        confirm.backgroundColor = .lightGray
        confirm.placeholder = "confirm password"
        confirm.frame = CGRect(x: 47, y: 300, width: 272, height: 40)
        confirm.textColor = .white
        confirm.layer.cornerRadius = 15.0
        confirm.layer.borderWidth = 2.0
        confirm.layer.borderColor = UIColor.lightGray.cgColor
        
        let email = UITextField()
        email.backgroundColor = .lightGray
        email.placeholder = "password"
        email.frame = CGRect(x: 47, y: 350, width: 272, height: 40)
        email.textColor = .white
        email.layer.cornerRadius = 15.0
        email.layer.borderWidth = 2.0
        email.layer.borderColor = UIColor.lightGray.cgColor
        
        let buttonCreate = UIButton()
        buttonCreate.setTitle("Ready to cook", for: .normal)
        buttonCreate.setTitleColor(UIColor.white, for: .normal)
        buttonCreate.backgroundColor = .systemPink
        buttonCreate.frame = CGRect(x: 47, y: 520, width: 274, height: 77)
        buttonCreate.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        buttonCreate.layer.cornerRadius = 15.0
        buttonCreate.layer.borderWidth = 2.0
        buttonCreate.layer.borderColor = UIColor.systemPink.cgColor
        
        super.view.addSubview(buttonCreate)
        super.view.addSubview(login)
        super.view.addSubview(password)
        super.view.addSubview(confirm)
        super.view.addSubview(email)
    }
    @objc func buttonClicked(sender : UIButton) {
           let vc = RootViewController()
           vc.modalPresentationStyle = .fullScreen
           self.present(vc, animated: true, completion: nil)
           print("Create Clicked")
       }
}
