//
//  ViewController.swift
//  RecipeFinder
//
//  Created by Наталья Автухович on 08.07.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import UIKit
import CryptoSwift
import SnapKit
import Alamofire
import Lottie
import AuthenticationServices


class ViewController: UIViewController {
    
    var label = UILabel()
    var label2 = UILabel()
    var buttonLogin = NeoButton()
    var buttonRegistr = NeoButton()
    var image = UIImage(named: "image 1.jpg")
    var warning =  UILabel()
    var email = GrayTextField()
    var password = GrayTextField()
    private var name: [String] = [""]
    let defaults = UserDefaults.standard
    var scrollView = UIScrollView()
    
    
    let animation = Animation.named("food")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        view.layer.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1).cgColor
        
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Recipe Finder"
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        
        label2.frame = CGRect(x: 45, y: 104, width: 286, height: 83)
        label2.textColor = UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1)
        label2.font = UIFont(name: "Harmattan-Regular", size: 25)
        label2.numberOfLines = 0
        label2.lineBreakMode = .byWordWrapping
        label2.textAlignment = .center
        label2.text = NSLocalizedString("Enter products. We'll show the recipe.", comment: "")
        
        
        buttonLogin.load(title: NSLocalizedString("login", comment: ""), frame: CGRect(x: 0, y: 500, width: UIScreen.main.bounds.width * 0.50, height: 58))

        buttonLogin.addTarget(self, action: #selector(self.loginButtonClicked2(sender:)), for: .touchUpInside)
        buttonLogin.addTarget(self, action: #selector(self.loginButtonClicked(sender:)), for: .touchDown)

        buttonRegistr.load(title: "sign up", frame: CGRect(x: 0, y: 600, width: UIScreen.main.bounds.width * 0.50, height: 58))
        buttonRegistr.addTarget(self, action: #selector(self.registerButtonClicked2(sender:)), for: .touchUpInside)
        buttonRegistr.addTarget(self, action: #selector(self.registerButtonClicked(sender:)), for: .touchDown)
        
        let animationView = AnimationView(animation: animation)
        animationView.frame = CGRect(x: 58, y: 210, width: 180, height: 180)
        animationView.loopMode = .loop
        animationView.play()
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        scrollView.addSubview(label)
        // тут не делал функцию потому что top равна superview
        label.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(100)
                make.centerX.equalToSuperview()
                make.height.equalTo(80)
            make.width.equalToSuperview().offset(20)
            }
        
        scrollView.addSubview(label2)
        MakeConstraints(view: label2, topView: label, topViewOffset: 15, height: 83, multipliedWidth: 0.80)
        
        scrollView.addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.top.equalTo(label2.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(180)
            make.width.equalTo(180)
        }
        
        scrollView.addSubview(buttonLogin)
        MakeConstraints(view: buttonLogin, topView: animationView, topViewOffset: 50, height: 60, multipliedWidth: 0.50)
        
        scrollView.addSubview(buttonRegistr)
        MakeConstraints(view: buttonRegistr, topView: buttonLogin, topViewOffset: 50, height: 60, multipliedWidth: 0.50)
        
        super.view.addSubview(scrollView)
        
        ScrollViewConstraints(view: scrollView)
    }
    
    @objc func loginButtonClicked(sender : NeoButton){
        sender.layer.sublayers?.removeFirst(2)
    }
    
    @objc func loginButtonClicked2(sender : NeoButton) {
        sender.setShadows()
        let vc = LoginController()
        self.present(vc, animated: true, completion: nil)

    }
    
    @objc func registerButtonClicked2(sender : NeoButton) {
        sender.setShadows()
        let viewc = RegistrationController()
        self.present(viewc, animated: true, completion: nil)
    }
    
    @objc func registerButtonClicked(sender : NeoButton) {
        sender.layer.sublayers?.removeFirst(2)
    }
}


public func auth(email: String, password: String, with completion: @escaping (String) -> ()){
    let url = URL(string: "https://recipe-finder-api-nodejs.herokuapp.com/login")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    // Set HTTP Request Headers
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let newUser = [
        "email": "\(email)",
        "password": "\(password)"
    ]
    
    let jsonData = try! JSONEncoder().encode(newUser)
    request.httpBody = jsonData
    
    URLSession.shared.dataTask(with: request){
        data, response, error in
        if let error = error {
            print("Error! \(error)")
        }
        if let data = data{
            
            if let result = String(data: data, encoding: .utf8){
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
        
    }.resume()
    
}

