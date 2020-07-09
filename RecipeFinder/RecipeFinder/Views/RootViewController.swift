//
//  RootViewController.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/9/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import  UIKit
class RootViewController: UIViewController{
    private var x: Int = 0
    override func viewDidLoad() {
        if (x == 0) // if user logged in
        {
        super.viewDidLoad()
        view.backgroundColor = .white
        // tab bar and etc
        }
        else{
            // TODO: present ViewController (login/sign up)
            // это не робит!
            let loginVc = ViewController()
            loginVc.modalPresentationStyle = .fullScreen
            present(loginVc, animated: false)
        }
    }
}
