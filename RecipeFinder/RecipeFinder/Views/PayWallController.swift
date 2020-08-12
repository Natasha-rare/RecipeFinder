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
    let restore = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .white
        
        Purchases.shared.offerings { (offerings, error) in
            if let packages = offerings?.current?.availablePackages {
                // Display packages for sale
                pkg = packages[0]
            }
        }
        btn.load(title: "Start trial", frame: CGRect(x: 100, y: 300, width: 200, height: 50))
        btn.addTarget(self, action: #selector(self.tapped(sender:)), for: .touchDown)
        restore.setTitle("Restore purchases", for: .normal)
        restore.setTitleColor(.gray, for: .normal)
        restore.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        restore.frame = CGRect(x: 100, y: 380, width: 150, height: 50)
        restore.addTarget(self, action: #selector(self.restoreTapped(sender:)), for: .touchDown)
        super.view.addSubview(btn)
        super.view.addSubview(restore)
}
    
    @objc func tapped(sender: NeoButton){
        showSpinner(onView: self.view)
        Purchases.shared.purchasePackage(pkg) { (transaction, purchaserInfo, error, userCancelled) in
            if purchaserInfo?.entitlements["Chef version"]?.isActive == true {
            removeSpinner()
            self.dismiss(animated: true, completion: nil)
          }
            if userCancelled{
                removeSpinner()
            }
        }
    }
    
    @objc func restoreTapped(sender: UIButton){
        showSpinner(onView: self.view)
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            if purchaserInfo?.entitlements["Chef version"]?.isActive == true {
              removeSpinner()
              self.dismiss(animated: true, completion: nil)
            }
            else{
                //tell user to buy subscription
                print("NEED TO BUY")
                removeSpinner()
            }
        }
    }
}
