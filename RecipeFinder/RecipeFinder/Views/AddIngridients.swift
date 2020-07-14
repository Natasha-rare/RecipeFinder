//
//  AddIngridients.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/9/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit
class SecondaryViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        let label = UILabel()
        label.frame = CGRect(x: 3, y: 85, width: 370, height: 53)
        label.textColor = UIColor.white
        label.text = "Input Ingredients"
        label.font = UIFont(name: "Harmattan-Regular", size: 30)
        label.textAlignment = .center
       
        let label2 = UILabel()
        label2.frame = CGRect(x: 8, y: 322, width: 360, height: 49)
        label2.textColor = UIColor.lightGray
        label2.text = "Recognized Text"
        label2.font = UIFont(name: "Harmattan-Regular", size: 30)
        label2.textAlignment = .center
        
        let buttonDone = UIButton()
        buttonDone.setTitle("DONE", for: .normal)
        buttonDone.setTitleColor(UIColor.white, for: .normal)
        buttonDone.backgroundColor = .systemPink
        buttonDone.frame = CGRect(x: 47, y: 476, width: 274, height: 77)
        buttonDone.addTarget(self, action: #selector(self.buttonClicked_DONE), for: .touchUpInside)
        
        let image = UIImage(named: "microphone 1.jpg")
        let imageMicro = UIImageView(image: image)
        imageMicro.frame = CGRect(x: 144, y: 592, width: 87, height: 87)
        imageMicro.tintColor = UIColor(red: 0.847, green: 0.553, blue: 0.039, alpha: 1)
        
        super.view.addSubview(label2)
        super.view.addSubview(label)
        super.view.addSubview(buttonDone)
        super.view.addSubview(imageMicro)
    }

    @objc func buttonClicked_DONE(sender : UIButton) {
            print("Button 'DONE' Clicked")
        }
}

