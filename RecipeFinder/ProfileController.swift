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
    var buttonExit = UIButton()
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
        buttonExit.setTitle("Log out", for: .normal)
        buttonExit.setTitleColor(UIColor.white, for: .normal)
        buttonExit.backgroundColor = .systemPink
        buttonExit.frame = CGRect(x: 47, y: 520, width: 274, height: 77)
        buttonExit.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        buttonExit.layer.cornerRadius = 15.0
        buttonExit.layer.borderWidth = 2.0
        buttonExit.layer.borderColor = UIColor.systemPink.cgColor
        super.view.addSubview(buttonExit)
    }
    @objc func buttonClicked(sender: UIButton){
        let vc = ViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        print("Button1 Clicked")
    }
}
