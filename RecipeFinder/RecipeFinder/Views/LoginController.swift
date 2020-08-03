//
//  LoginController.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/28/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit
import Lottie
import Alamofire

class LoginController: UIViewController {

var label = UILabel()
var warning =  UILabel()
var email = GrayTextField()
var password = GrayTextField()
let buttonLogin = NeoButton()
private var name: [String] = [""]
let defaults = UserDefaults.standard
var scrollView = UIScrollView()


override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
    view.layer.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1).cgColor
    
    label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
    label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    label.text = "Login"
    //label.font = UIFont(name: "Georgia", size: 43)
    label.font = UIFont.systemFont(ofSize: 43, weight: .semibold)
    label.textAlignment = .center
    
    email.loadField(placeholderText: NSLocalizedString("email", comment: ""), isSecure: false, frame: CGRect(x: 58, y: 150, width: 257, height: 58))
    email.delegate = self
    
    password.loadField(placeholderText: NSLocalizedString("password", comment: ""), isSecure: true, frame: CGRect(x: 58, y: 200, width: 257, height: 58))
    password.delegate = self
    
    warning.text = NSLocalizedString("Password should contain capital, lowercase letters and numbers", comment: "")
    warning.frame = CGRect(x: 10, y: 395, width: 350, height: 60)
    warning.textColor = UIColor.red
    warning.font = UIFont.systemFont(ofSize: 18, weight: .thin)
    warning.numberOfLines = 2
    warning.textAlignment = .center
    
    buttonLogin.load(title: NSLocalizedString("login", comment: ""), frame: CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width * 0.50, height: 58))

    buttonLogin.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
    buttonLogin.addTarget(self, action: #selector(self.buttonClicked2(sender:)), for: .touchDown)
    
    scrollView.addSubview(label)
    label.snp.makeConstraints { (make) -> Void in
    make.top.equalToSuperview().offset(50)
        make.centerX.equalToSuperview()
        make.height.equalTo(80)
    make.width.equalToSuperview().offset(20)
    }
    
    scrollView.addSubview(email)
    MakeConstraints(view: email, topView: label, topViewOffset: 50, height: 60, multipliedWidth: 0.80)
    
    scrollView.addSubview(password)
    MakeConstraints(view: password, topView: email, topViewOffset: 20, height: 60, multipliedWidth: 0.80)
    
    scrollView.addSubview(buttonLogin)
    MakeConstraints(view: buttonLogin, topView: password, topViewOffset: 50, height: 60, multipliedWidth: 0.50)
    
    super.view.addSubview(scrollView)
    
    ScrollViewConstraints(view: scrollView)
    
    }

     @objc func buttonClicked2(sender : NeoButton){
            sender.layer.sublayers?.removeFirst(2)
        }
        
        @objc func buttonClicked(sender : NeoButton) {
            sender.setShadows()
            let Password = password.text
            let Email = email.text
            
            let password_check = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$")
            let email_checker = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
            let email_check = NSPredicate(format: "SELF MATCHES %@ ", email_checker)
            if Password == "" || Email == ""{
                warning.text = "You've entered an empty value"
                removeSpinner()
                scrollView.addSubview(warning)
                MakeConstraints(view: warning, topView: password, topViewOffset: 20, height: 20, multipliedWidth: 1)
            }
            else{
                if password_check.evaluate(with: Password) == true && email_check.evaluate(with: Email) == true
                    {
                        let hashedPassword = ("\(Password!).\(Email!)").sha256()
                        showSpinner(onView: scrollView)
                        auth(email: Email!, password: hashedPassword){
                        result in
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
                            let savedVC = SavedController()
                            savedVC.fetchLinks()
                            savedVC.refresh()
                            let groceryVC = GroceryController()
                            groceryVC.fetchIngredients { (value) in
                                groceryIngridients = value
                                self.defaults.set(value, forKey: "grocery")
                                groceryVC.refresh()
                            }
                            removeSpinner()
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                        else if result == "Incorrect password!"{
                            self.warning.text = "Incorrect password :("
                            removeSpinner()
                            self.scrollView.addSubview(self.warning)
                            MakeConstraints(view: self.warning, topView: self.password, topViewOffset: 20, height: 20, multipliedWidth: 1)
                        }
                        else if result == "Need to register!"{
                            self.warning.textColor = .red
                            self.warning.text = "Hey! Seems you have to register!"
                            removeSpinner()
                            self.scrollView.addSubview(self.warning)
                            MakeConstraints(view: self.warning, topView: self.password, topViewOffset: 20, height: 20, multipliedWidth: 1)
                        }
                        else{
                            self.warning.textColor = .red
                            self.warning.text = "Something went wrong, try again!"
                            removeSpinner()
                            self.scrollView.addSubview(self.warning)
                            MakeConstraints(view: self.warning, topView: self.password, topViewOffset: 20, height: 20, multipliedWidth: 1)
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
                    MakeConstraints(view: self.warning, topView: self.password, topViewOffset: 20, height: 20, multipliedWidth: 1)
                }
                else {
                    warning.text = "This email address doesn't exist"
                    removeSpinner()
                    scrollView.addSubview(warning)
                    MakeConstraints(view: self.warning, topView: self.password, topViewOffset: 20, height: 20, multipliedWidth: 1)
                }
               
            }
        }
        
        func setdefault(Email: String, Password: String, Logged: Bool){
            self.defaults.set(Email, forKey: "email")
            self.defaults.set(Password, forKey: "password")
            self.defaults.set(Logged, forKey: "logged")
        }
    }
