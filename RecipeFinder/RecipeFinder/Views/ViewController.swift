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
    var buttonStart = NeoButton()
    var buttonRegistr = UIButton()
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
        
        email.loadField(placeholderText: NSLocalizedString("email", comment: ""), isSecure: false, frame: CGRect(x: 58, y: 468, width: 257, height: 58))
        email.delegate = self
        
        password.loadField(placeholderText: NSLocalizedString("password", comment: ""), isSecure: false, frame: CGRect(x: 58, y: 536, width: 257, height: 58))
        password.delegate = self
        
        warning.text = NSLocalizedString("Password should contain capital, lowercase letters and numbers", comment: "")
        warning.frame = CGRect(x: 10, y: 395, width: 350, height: 60)
        warning.textColor = UIColor.red
        warning.font = UIFont.systemFont(ofSize: 18, weight: .thin)
        warning.numberOfLines = 2
        warning.textAlignment = .center
        
        buttonStart.load(title: NSLocalizedString("let's go", comment: ""), frame: CGRect(x: 0, y: 643, width: UIScreen.main.bounds.width * 0.50, height: 58))

        buttonStart.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        buttonStart.addTarget(self, action: #selector(self.buttonClicked2(sender:)), for: .touchDown)

        buttonRegistr.setTitle(NSLocalizedString("Don’t have an account?", comment: ""), for: .normal)
        buttonRegistr.setTitleColor(UIColor(red: 0.604, green: 0.604, blue: 0.604, alpha: 1), for: .normal)
        buttonRegistr.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        buttonRegistr.frame = CGRect(x: 0, y: 750, width: 375, height: 33)
        buttonRegistr.addTarget(self, action: #selector(self.buttonRegistr(sender:)), for: .touchUpInside)
        
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
        
        scrollView.addSubview(email)
        MakeConstraints(view: email, topView: animationView, topViewOffset: 40, height: 60, multipliedWidth: 0.80)
        
        scrollView.addSubview(password)
        MakeConstraints(view: password, topView: email, topViewOffset: 20, height: 60, multipliedWidth: 0.80)
        
        
        scrollView.addSubview(buttonStart)
        MakeConstraints(view: buttonStart, topView: password, topViewOffset: 50, height: 60, multipliedWidth: 0.50)
        
        scrollView.addSubview(buttonRegistr)
        MakeConstraints(view: buttonRegistr, topView: buttonStart, topViewOffset: 50, height: 33, multipliedWidth: 0.80)
        
        super.view.addSubview(scrollView)
        
        ScrollViewConstraints(view: scrollView)
    }
    
    @objc func buttonClicked2(sender : NeoButton){
        sender.setShadows()
    }
    
    @objc func buttonClicked(sender : NeoButton) {
        sender.layer.sublayers?.removeFirst(2)
        let Password = password.text
        let Email = email.text
        showSpinner(onView: scrollView)
        
        let password_check = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$")
        let email_checker = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let email_check = NSPredicate(format: "SELF MATCHES %@ ", email_checker)
        if Password == "" || Email == ""{
            warning.text = "You've entered an empty value"
            removeSpinner()
            scrollView.addSubview(warning)
            AddConstraints(view: warning, top: 395, height: 60, width: 350)
        }
        else{
            if password_check.evaluate(with: Password) == true && email_check.evaluate(with: Email) == true
                {
                    let hashedPassword = ("\(Password!).\(Email!)").sha256()
                    
                auth(email: Email!, password: hashedPassword){
                    result in
                    print("email: \(Email!) \n password: \(hashedPassword)")
                    print(result)
                    if result == "Logged in!"{
                        let url = "https://recipe-finder-api-nodejs.herokuapp.com/?email=\(Email!)&password=\(hashedPassword)"
                        AF.request(url, method: .get).response{
                            response in
                            if let data = response.value{
                                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                                    
                                if let dict = json as? [String: Any]{
                                    print(dict["name"] as! String)
                                    self.defaults.set(dict["name"] as! String, forKey: "name")
                                }
                            }
                        }
                        
                        
                        self.setdefault(Email: Email!, Password: hashedPassword, Logged: true)
                        
                        let vc = RootViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                    else if result == "Incorrect password!"{
                        self.warning.text = "Incorrect password :("
                        removeSpinner()
                        self.scrollView.addSubview(self.warning)
                        AddConstraints(view: self.warning, top: 395, height: 60, width: 350)
                    }
                    else{
                        self.warning.textColor = .red
                        self.warning.text = "Hey! Seems you have to register!"
                        removeSpinner()
                        self.scrollView.addSubview(self.warning)
                        AddConstraints(view: self.warning, top: 395, height: 60, width: 350)
                    }
                }
                
            }
            else if password_check.evaluate(with: Password) == false
            {
                if Password!.count < 8 {
                    warning.text = "Your password is too short"
                }
                else {
                    warning.text = "Password should contain capital, lowercase letters and numbers"
                }
                removeSpinner()
                scrollView.addSubview(warning)
                AddConstraints(view: warning, top: 395, height: 60, width: 350)
            }
            else {
                warning.text = "This email address doesn't exist"
                removeSpinner()
                scrollView.addSubview(warning)
                AddConstraints(view: warning, top: 395, height: 60, width: 350)
            }
           
        }
    }
    
    func setdefault(Email: String, Password: String, Logged: Bool){
        self.defaults.set(Email, forKey: "email")
        self.defaults.set(Password, forKey: "password")
        self.defaults.set(Logged, forKey: "logged")
    }
    
    @objc func buttonRegistr(sender : UIButton) {
        let viewc = RegistrationController()
        self.present(viewc, animated: true, completion: nil)
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

