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
    let scrollView = UIScrollView()
    let label = UILabel()
    let label2 = UILabel()
    let buttonDone = UIButton()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        label.frame = CGRect(x: 3, y: 85, width: 370, height: 53)
        label.textColor = UIColor.white
        label.text = "Input Ingredients"
        label.font = UIFont(name: "Harmattan-Regular", size: 30)
        label.textAlignment = .center
       
        label2.frame = CGRect(x: 8, y: 322, width: 360, height: 49)
        label2.textColor = UIColor.lightGray
        label2.text = "Recognized Text"
        label2.font = UIFont(name: "Harmattan-Regular", size: 30)
        label2.textAlignment = .center
        
        buttonDone.setTitle("DONE", for: .normal)
        buttonDone.setTitleColor(UIColor.white, for: .normal)
        buttonDone.backgroundColor = .systemPink
        buttonDone.frame = CGRect(x: 47, y: 476, width: 274, height: 77)
        buttonDone.addTarget(self, action: #selector(self.buttonClicked_DONE), for: .touchUpInside)
        
        let image = UIImage(named: "microphone 1.jpg")
        let imageMicro = UIImageView(image: image)
        imageMicro.frame = CGRect(x: 144, y: 592, width: 87, height: 87)
        imageMicro.tintColor = UIColor(red: 0.847, green: 0.553, blue: 0.039, alpha: 1)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 800)
        
        scrollView.addSubview(label2)
        AddConstraints(view: label2, top: 322, height: 49, width: 360)
        
        scrollView.addSubview(label)
        AddConstraints(view: label, top: 85, height: 53, width: 370)
        
        scrollView.addSubview(buttonDone)
        AddConstraints(view: buttonDone, top: 478, height: 77, width: 274)
        
        scrollView.addSubview(imageMicro)
        AddConstraints(view: imageMicro, top: 592, height: 87, width: 87)
        
        super.view.addSubview(scrollView)
        ScrollViewConstraints(view: scrollView)
        
    }

    @objc func buttonClicked_DONE(sender : UIButton) {
            // function is overriden in extensions
        }
}

