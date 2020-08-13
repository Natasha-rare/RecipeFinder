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
    var label = UILabel()
    var back = UIImageView(image: UIImage(named: "Ramen-on-a-rainy-day--iphone-wallpaper-ilikewallpaper_com 1.png"))
    var text = UILabel()
    var text2 = UILabel()
    var price = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = UIColor(red: 0.125, green: 0.145, blue: 0.18, alpha: 1)
        
        Purchases.shared.offerings { (offerings, error) in
            if let packages = offerings?.current?.availablePackages {
                // Display packages for sale
                pkg = packages[0]
            }
        }
        
        price.frame = CGRect(x: 90, y: 560, width: 190, height: 46)
        price.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        price.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        price.textAlignment = .center
        price.text = "Only 0.99 $/month"
        
        text2.frame = CGRect(x: 18, y: 740, width: 340, height: 90)
        text2.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        text2.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        text2.numberOfLines = 0
        text2.lineBreakMode = .byWordWrapping
        text2.textAlignment = .center
        text2.text = "Subscription will be charged to your iTunes account.\nSubscription will automatically renew unless canceled within 24-hours before the end of the current period. You can cancel anytime with your iTunes account settings. Any unused portion of a free trial will be forfeited if you purchase a subscription.\n"

        text.frame = CGRect(x: 100, y: 100, width: 203, height: 160)
        text.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        text.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        text.numberOfLines = 0
        text.lineBreakMode = .byWordWrapping
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.71
        
        text.attributedText = NSMutableAttributedString(string: "✅  Unlimited access\n✅  New features\n✅  24/7 support", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        label.frame = CGRect(x: 0, y: 18, width: 375, height: 79)
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.text = "Become a chief"
        label.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        label.textAlignment = .center
        
        btn.load(title: "Start trial", frame: CGRect(x: 30, y: 610, width: 300, height: 60))
        btn.layer.sublayers?.removeLast(2)
        btn.addTarget(self, action: #selector(self.tapped(sender:)), for: .touchDown)
        
        restore.setTitle("Restore purchases", for: .normal)
        restore.setTitleColor(.lightGray, for: .normal)
        restore.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        restore.frame = CGRect(x: 30, y: 670, width: 300, height: 60)
        restore.addTarget(self, action: #selector(self.restoreTapped(sender:)), for: .touchDown)
        
        super.view.addSubview(back)
        AddConstraints(view: back, top: 0, height: Int(super.view.bounds.height), width: Int(super.view.bounds.width))
        
        
        super.view.addSubview(price)
        AddConstraints(view: price, top: 560, height: 46, width: 190)
        
        super.view.addSubview(text)
        AddConstraints(view: text, top: 100, height: 161, width: 203)
        
        super.view.addSubview(text2)
        AddConstraints(view: text2, top: 740, height: 90, width: 340)
        
        super.view.addSubview(label)
        // тут не делал функцию потому что top равна superview
        label.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(50)
                make.centerX.equalToSuperview()
                make.height.equalTo(80)
            make.width.equalToSuperview().offset(20)
            }
        
        
        super.view.addSubview(btn)
        AddConstraints(view: btn, top: 610, height: 60, width: 300)
        super.view.addSubview(restore)
        AddConstraints(view: restore, top: 670, height: 60, width: 300)
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
