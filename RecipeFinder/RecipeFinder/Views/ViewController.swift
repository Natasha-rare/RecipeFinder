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
        label.font = UIFont(name: "MarkerFelt-Wide", size: 38)
        label.textAlignment = .center
        
        let label2 = UILabel()
        label2.frame = CGRect(x: 35, y: 138, width: 309, height: 93)
        label2.textColor = UIColor.systemBlue
        label2.text = "Enter your products. We’ll show you the recipe"
        label2.font = UIFont(name: "MarkerFelt-Thin", size: 27)
        label2.numberOfLines = 2
        label2.textAlignment = .center
        
        let login = UITextField()
        login.backgroundColor = .lightGray
        login.placeholder = "login"
        login.frame = CGRect(x: 47, y: 246, width: 272, height: 65)
        login.textColor = .white
        login.layer.cornerRadius = 15.0
        login.layer.borderWidth = 2.0
        login.layer.borderColor = UIColor.lightGray.cgColor
        
        let password = UITextField()
        password.backgroundColor = .lightGray
        password.placeholder = "password"
        password.frame = CGRect(x: 47, y: 341, width: 272, height: 65)
        password.textColor = .white
        password.layer.cornerRadius = 15.0
        password.layer.borderWidth = 2.0
        password.layer.borderColor = UIColor.lightGray.cgColor
        
        let buttonStart = UIButton()
        buttonStart.setTitle("Let's go", for: .normal)
        buttonStart.setTitleColor(UIColor.white, for: .normal)
        buttonStart.backgroundColor = .systemPink
        buttonStart.frame = CGRect(x: 47, y: 450, width: 274, height: 60)
        buttonStart.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        buttonStart.layer.cornerRadius = 15.0
        buttonStart.layer.borderWidth = 2.0
        buttonStart.layer.borderColor = UIColor.systemPink.cgColor
        
        let buttonRegistr = UIButton()
        buttonRegistr.setTitle("Registration", for: .normal)
        buttonRegistr.setTitleColor(UIColor.white, for: .normal)
        buttonRegistr.backgroundColor = .systemPink
        buttonRegistr.frame = CGRect(x: 47, y: 520, width: 274, height: 60)
        buttonRegistr.addTarget(self, action: #selector(self.buttonRegistr(sender:)), for: .touchUpInside)
        buttonRegistr.layer.cornerRadius = 15.0
        buttonRegistr.layer.borderWidth = 2.0
        buttonRegistr.layer.borderColor = UIColor.systemPink.cgColor
        
        let image = UIImage(named: "image 1.jpg")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 57, y: 583, width: 262, height: 195)
        
        super.view.addSubview(label)
        super.view.addSubview(label2)
        super.view.addSubview(login)
        super.view.addSubview(password)
        super.view.addSubview(imageView)
        super.view.addSubview(buttonStart)
        super.view.addSubview(buttonRegistr)
    }
    
    @objc func buttonClicked(sender : UIButton) {
        let vc = RootViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        print("Button1 Clicked")
    }
    
    @objc func buttonRegistr(sender : UIButton) {
        let viewc = RegistrationController()
        viewc.modalPresentationStyle = .fullScreen
        self.present(viewc, animated: true, completion: nil)
        print("Button2 Clicked")
    }
}


