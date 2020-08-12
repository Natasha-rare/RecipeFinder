//
//  PayWallController.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 8/12/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import  UIKit
import Purchases

var pkg = Purchases.Package()
class PayWallController: UIViewController{
    let btn = NeoButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .white
        
        Purchases.shared.offerings { (offerings, error) in
            if let offerings = offerings {
                pkg = offerings.current!.monthly!
            }
        }
        btn.load(title: "Pay", frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: UIScreen.main.bounds.width*0.80, height: 50))
        btn.addTarget(self, action: #selector(self.tapped(sender:)), for: .touchDown)
        super.view.addSubview(btn)
}
    
    @objc func tapped(sender: NeoButton){
        Purchases.shared.purchasePackage(pkg) { (transaction, purchaserInfo, error, userCancelled) in
            showSpinner(onView: self.view)
            if purchaserInfo?.entitlements["Chef version"]?.isActive == true {
            removeSpinner()
            print("UNLOCKED")
            print(purchaserInfo?.entitlements["Chef version"])
            self.dismiss(animated: true, completion: nil)
          }
            if userCancelled{
                removeSpinner()
            }
        }
    }
}
