//
//  ViewController.swift
//  RecipeFinder
//
//  Created by Наталья Автухович on 08.07.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        
        let label = UILabel()
        label.frame = CGRect(x: 3, y: 85, width: 370, height: 53)
        label.textColor = UIColor.blue
        label.text = "Recipe Finder"
        label.font = UIFont(name: "Roboto", size: 38)
        label.textAlignment = .center
        
        let label2 = UILabel()
        label2.frame = CGRect(x: 35, y: 138, width: 309, height: 93)
        label2.textColor = UIColor.blue
        label2.text = "Enter your products. We’ll show you the recipe"
        label2.font = UIFont(name: "Roboto", size: 27)
        label2.numberOfLines = 2
        label2.textAlignment = .center
        
        let login = UITextField()
        login.backgroundColor = .lightGray
        login.placeholder = "login"
        login.frame = CGRect(x: 47, y: 246, width: 272, height: 65)
        login.textColor = .white
        
        let password = UITextField()
        password.backgroundColor = .lightGray
        password.placeholder = "password"
        password.frame = CGRect(x: 47, y: 341, width: 272, height: 65)
        password.textColor = .white
        
        let buttonStart = UIButton()
        buttonStart.setTitle("Let's go", for: .normal)
        buttonStart.setTitleColor(UIColor.white, for: .normal)
        buttonStart.backgroundColor = .systemPink
        buttonStart.frame = CGRect(x: 47, y: 476, width: 274, height: 77)
        buttonStart.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        
//        let image = UIImage(cgImage: <#T##CGImage#>)
        
        super.view.addSubview(label)
        super.view.addSubview(label2)
        super.view.addSubview(login)
        super.view.addSubview(password)
        super.view.addSubview(buttonStart)
        
    }
    
    @objc func buttonClicked(sender : UIButton) {
        
        print("Button Clicked")
    }
    
}


