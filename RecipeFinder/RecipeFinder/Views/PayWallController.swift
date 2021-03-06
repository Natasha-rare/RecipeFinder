//
//  PayWallController.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 8/12/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit
import Purchases
import SafariServices

var pkg = Purchases.Package()
class PayWallController: UIViewController{
    let btn = NeoButton()
    let restore = UIButton()
    var label = UILabel()
    var back = UIImageView(image: UIImage(named: "Ramen-on-a-rainy-day--iphone-wallpaper-ilikewallpaper_com 1.png"))
    var text = UILabel()
    var text2 = UILabel()
    var price = UILabel()
    var terms = UIButton()
    var privacy = UIButton()
    var scrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = UIColor(red: 0.125, green: 0.145, blue: 0.18, alpha: 1)
        
        Purchases.shared.offerings { (offerings, error) in
            if let packages = offerings?.current?.availablePackages {
                // Display packages for sale
                pkg = packages[0]
            }
        }
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 850)
        
        
//        let langCode = Locale.current.languageCode ?? ""
//        let regionCode = Locale.current.regionCode ?? ""
//        Locale.current.identifier
        var indentifier = NSLocale.current.identifier
        
        if indentifier.count != 4{indentifier = "en_US"}
        
        var product = SKProduct(identifier: "chief.version", price: "0.99", priceLocale: Locale(identifier: indentifier))
        var priseStr = ""
        priseStr = product.localizedPrice()
        
        price.frame = CGRect(x: 90, y: 650, width: 190, height: 46)
        price.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        price.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        price.textAlignment = .center
        price.text = "Then \(priseStr)/month"
        
        text2.frame = CGRect(x: 18, y: 720, width: 340, height: 90)
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
        label.text = "Chef version"
        label.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        label.textAlignment = .center
        
        btn.load(title: "Start free 1-week trial", frame: CGRect(x: 30, y: 560, width: 300, height: 60))
        btn.layer.sublayers?.removeLast(2)
        btn.addTarget(self, action: #selector(self.tapped(sender:)), for: .touchDown)
        
        restore.setTitle("Restore purchases", for: .normal)
        restore.setTitleColor(.lightGray, for: .normal)
        restore.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        restore.frame = CGRect(x: 30, y: 670, width: 300, height: 60)
        restore.addTarget(self, action: #selector(self.restoreTapped(sender:)), for: .touchDown)
        
        terms.setTitle("Terms of use", for: .normal)
        terms.setTitleColor(.lightGray, for: .normal)
        terms.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        terms.frame = CGRect(x: 30, y: 780, width: 150, height: 60)
        terms.addTarget(self, action: #selector(self.termsTapped(_ :)), for: .touchDown)
        
        privacy.setTitle("Privacy Policy", for: .normal)
        privacy.setTitleColor(.lightGray, for: .normal)
        privacy.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        privacy.frame = CGRect(x: 210, y: 780, width: 150, height: 60)
        privacy.addTarget(self, action: #selector(self.privacyTapped(_:)), for: .touchDown)
        
        scrollView.addSubview(back)
        AddConstraints(view: back, top: 0, height: 850, width: Int(super.view.bounds.width))
        
        scrollView.addSubview(price)
        AddConstraints(view: price, top: 650, height: 46, width: 190)
        
        scrollView.addSubview(privacy)
        ImageConstraints(view: privacy, top: 780, width: 150, height: 60, left: 210)
        
        scrollView.addSubview(terms)
        ImageConstraints(view: terms, top: 780, width: 150, height: 60, left: 30)
        
        scrollView.addSubview(text)
        AddConstraints(view: text, top: 100, height: 161, width: 203)
        
        scrollView.addSubview(text2)
        AddConstraints(view: text2, top: 720, height: 90, width: 340)
        
        scrollView.addSubview(label)
        // тут не делал функцию потому что top равна superview
        label.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(50)
                make.centerX.equalToSuperview()
                make.height.equalTo(80)
            make.width.equalToSuperview().offset(20)
            }
        
        
        scrollView.addSubview(btn)
        AddConstraints(view: btn, top: 560, height: 60, width: 300)
        
        scrollView.addSubview(restore)
        AddConstraints(view: restore, top: 670, height: 60, width: 300)
        
        super.view.addSubview(scrollView)
        ScrollViewConstraints(view: scrollView)
}
    @objc func termsTapped(_ sender: UIButton){
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: URL(string: "http://recipef1nder.tilda.ws/turmsofuse")!, configuration: config)
        present(vc, animated: true)
    }
    
    @objc func privacyTapped(_ sender: UIButton){
           let config = SFSafariViewController.Configuration()
           config.entersReaderIfAvailable = true
           let vc = SFSafariViewController(url: URL(string: "http://recipef1nder.tilda.ws/privacypollicy")!, configuration: config)
           present(vc, animated: true)
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
                removeSpinner()
                let imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: 250, height: 230))
                imageView.image = UIImage(named: "sad")
                let alert = UIAlertController(title: "No subscription found :(", message: nil, preferredStyle: .alert)
                alert.view.addSubview(imageView)
                let height = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350)
                let width = NSLayoutConstraint(item: alert.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
                alert.view.addConstraint(height)
                alert.view.addConstraint(width)

                alert.addAction(UIAlertAction(title: "Renew", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}
