//
//  RegistrationController.swift
//  RecipeFinder
//
//  Created by I on 10.07.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift
import Alamofire
import Purchases

class RegistrationController: UIViewController{
    var warning = UILabel()
    var email = GrayTextField()
    var label = UILabel()
    var password = GrayTextField()
    var name = GrayTextField()
    var confirm = GrayTextField()
    var buttonCreate = NeoButton()
    let scrollView = UIScrollView()
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        view.layer.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1).cgColor
        
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = NSLocalizedString("Registration", comment: "")
        label.font = UIFont.systemFont(ofSize: 43, weight: .semibold)
        label.textAlignment = .center
        
        name.loadField(placeholderText: NSLocalizedString("name", comment: ""), isSecure: false, frame: CGRect(x: 58, y: 152, width: 257, height: 58))
        name.delegate = self
        
        email.loadField(placeholderText: NSLocalizedString("email", comment: ""), isSecure: false, frame: CGRect(x: 58, y: 240, width: 257, height: 58))
        email.delegate = self
        
        password.loadField(placeholderText: NSLocalizedString("password", comment: ""), isSecure: true, frame: CGRect(x: 58, y: 318, width: 257, height: 58))
        password.delegate = self
        
        confirm.loadField(placeholderText: NSLocalizedString("repeat password", comment: ""), isSecure: true, frame: CGRect(x: 58, y: 396, width: 257, height: 58))
        confirm.delegate = self
        
        buttonCreate.load(title: NSLocalizedString("ready", comment: ""), frame: CGRect(x: 58, y: 516, width: UIScreen.main.bounds.width * 0.50, height: 58))
        buttonCreate.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        buttonCreate.addTarget(self, action: #selector(self.buttonClicked2(sender:)), for: .touchDown)
        
        warning.text = NSLocalizedString("Password should contain capital, lowercase letters and numbers", comment: "")
        warning.frame = CGRect(x: 0, y: 456, width: 257, height: 58)
        warning.textColor = UIColor.red
        warning.font = UIFont.systemFont(ofSize: 18, weight: .thin)
        warning.numberOfLines = 0
        warning.lineBreakMode = .byWordWrapping
        warning.textAlignment = .center
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        scrollView.addSubview(label)
        label.snp.makeConstraints { (make) -> Void in
        make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(80)
        make.width.equalToSuperview().offset(20)
        }
        
        scrollView.addSubview(name)
        MakeConstraints(view: name, topView: label, topViewOffset: 50, height: 60, multipliedWidth: 0.80)
        
        scrollView.addSubview(email)
        MakeConstraints(view: email, topView: name, topViewOffset: 20, height: 60, multipliedWidth: 0.80)
        
        scrollView.addSubview(password)
        MakeConstraints(view: password, topView: email, topViewOffset: 20, height: 60, multipliedWidth: 0.80)
        
        scrollView.addSubview(confirm)
        MakeConstraints(view: confirm, topView: password, topViewOffset: 20, height: 60, multipliedWidth: 0.80)
        
        scrollView.addSubview(buttonCreate)
        MakeConstraints(view: buttonCreate, topView: confirm, topViewOffset: 50, height: 60, multipliedWidth: 0.50)
        
        super.view.addSubview(scrollView)
        ScrollViewConstraints(view: scrollView)
    }
    
    @objc func buttonClicked2(sender : NeoButton){
        sender.layer.sublayers?.removeFirst(2)
    }
    
    func setdefault(Email: String, Password: String, Logged: Bool){
        self.defaults.set(Email, forKey: "email")
        self.defaults.set(Password, forKey: "password")
        self.defaults.set(Logged, forKey: "logged")
    }
    
    @objc func buttonClicked(sender : NeoButton) {
        sender.setShadows()
        showSpinner(onView: scrollView)
        
        let Password = password.text
        let Email = email.text?.lowercased()
        let Confirm = confirm.text
        let Name = name.text

        let password_check = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$")
        let email_checker = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let email_check = NSPredicate(format: "SELF MATCHES %@ ", email_checker)
        
        if Password == "" || Email == "" || Confirm == "" || Name == ""{
            warning.text =  NSLocalizedString("You've entered an empty value", comment: "")
            removeSpinner()
            scrollView.addSubview(warning)
            MakeConstraints(view: self.warning, topView: self.confirm, topViewOffset: 20, height: 20, multipliedWidth: 1)
        }
        else{
            if password_check.evaluate(with: Password) == true && email_check.evaluate(with: Email) == true && Password == Confirm
            {

                register(email: Email!, password: Password!, name: Name!){result in
                    if result == "Signed up!"{
                        self.setdefault(Email: Email!, Password: Password!, Logged: true)
                        self.defaults.set(self.name.text, forKey: "name")
                        
                        let imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: 250, height: 230))
                        imageView.image = UIImage(named: "email")
                        let alert = UIAlertController(title: "Please verify your account", message: nil, preferredStyle: .alert)
                        alert.view.addSubview(imageView)
                        let height = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350)
                        let width = NSLayoutConstraint(item: alert.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
                        alert.view.addConstraint(height)
                        alert.view.addConstraint(width)

                        alert.addAction(UIAlertAction(title: "No problem :)", style: .default, handler: {
                            action in
                            let vc = RootViewController()
                            let savedVC = SavedController()
                            savedVC.fetchLinks()
                            savedVC.refresh()
                            let groceryVC = GroceryController()
                            groceryVC.fetchIngredients { (value) in
                                groceryIngridients = value
                                groceryVC.refresh()
                            }
                            showSpinner(onView: self.scrollView)
                            let url = "https://recipe-finder-api-nodejs.herokuapp.com/?email=\(Email!)&password=\(Password)"
                            AF.request(url, method: .get).responseDecodable(of: User.self){
                                response in
                                if let data = response.value{
                                    self.defaults.set(data.id.uuidString, forKey: "id")
                                    Purchases.configure(withAPIKey: "VFHDsrBztyKUyesgOiBWtPqQoZtolcsz", appUserID: data.id.uuidString)
                                    }
                                    
                                }
                            self.defaults.set(savedLinks, forKey: "savedLinks")
                            self.defaults.set(groceryIngridients, forKey: "grocery")
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }))

                        self.present(alert, animated: true)
                    }
                    else if result == "User exists!"{
                        self.warning.textColor = .red
                        self.warning.text = NSLocalizedString("User with this email already exists!", comment: "")
                        removeSpinner()
                        self.scrollView.addSubview(self.warning)
                        MakeConstraints(view: self.warning, topView: self.confirm, topViewOffset: 20, height: 20, multipliedWidth: 1)
                        }
                    else{
                        removeSpinner()
                        self.warning.textColor = .red
                        self.warning.text = NSLocalizedString("There's something with the Internet, try again!", comment: "")
                        removeSpinner()
                        self.scrollView.addSubview(self.warning)
                        MakeConstraints(view: self.warning, topView: self.confirm, topViewOffset: 20, height: 20, multipliedWidth: 1)
                    }
                }
            }
            else if password_check.evaluate(with: Password) == false
            {
                if Password!.count < 8 {
                   warning.text = NSLocalizedString("Your password is too short", comment: "")
                }
                else {
                   warning.text = NSLocalizedString("Password should contain capital, lowercase letters and numbers", comment: "")
                }
                removeSpinner()
                scrollView.addSubview(warning)
                MakeConstraints(view: self.warning, topView: self.confirm, topViewOffset: 20, height: 20, multipliedWidth: 1)
            }
            else if Password != Confirm{
                warning.text = NSLocalizedString("Passwords are not equal", comment: "")
                removeSpinner()
                scrollView.addSubview(warning)
                MakeConstraints(view: self.warning, topView: self.confirm, topViewOffset: 20, height: 20, multipliedWidth: 1)
            }
            else {
                warning.text = NSLocalizedString("This email address doesn't exist", comment: "")
                removeSpinner()
                scrollView.addSubview(warning)
                MakeConstraints(view: self.warning, topView: self.confirm, topViewOffset: 20, height: 20, multipliedWidth: 1)
            }
        }
    }
}

public func register(email: String, password: String, name: String, with completion: @escaping (String) -> ()){
    let url = "https://recipe-finder-api-nodejs.herokuapp.com/register"

    let newUser = [
        "email": "\(email)",
        "password": "\(password)",
        "name": "\(name)"
    ]

    AF.request(url, method: .post, parameters: newUser, encoding: JSONEncoding.default).response{
        res in
            if let data = res.value{
                if let result = String(data: data!, encoding: .utf8){
                    completion(result)
                }
            }
            else{
                completion("error")
        }
        }
    }
