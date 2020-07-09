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
        label.frame = CGRect(x: 50, y: 50, width: 300, height: 40)
        label.textColor = UIColor.black
        label.text = "Recipe Finder"
        label.font = UIFont(name: "MarkerFelt-Thin", size: 45)
        
        
        let buttonStart = UIButton()
        buttonStart.setTitle("START", for: .normal)
        buttonStart.setTitleColor(UIColor.blue, for: .normal)
        buttonStart.frame = CGRect(x: 15, y: -50, width: 300, height: 500)
        buttonStart.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        
        super.view.addSubview(label)
        super.view.addSubview(buttonStart)
        
    }
    
    @objc func buttonClicked(sender : UIButton) {
        
        print("Button Clicked")
    }
    
}


