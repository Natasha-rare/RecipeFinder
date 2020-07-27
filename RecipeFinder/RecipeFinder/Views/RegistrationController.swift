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
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        
        name.loadField(placeholderText: NSLocalizedString("name", comment: ""), isSecure: false, frame: CGRect(x: 58, y: 152, width: 257, height: 58))
        name.delegate = self
        
        email.loadField(placeholderText: NSLocalizedString("email", comment: ""), isSecure: false, frame: CGRect(x: 58, y: 240, width: 257, height: 58))
        email.delegate = self
        
        password.loadField(placeholderText: NSLocalizedString("password", comment: ""), isSecure: false, frame: CGRect(x: 58, y: 318, width: 257, height: 58))
        password.delegate = self
        
        confirm.loadField(placeholderText: NSLocalizedString("repeat password", comment: ""), isSecure: false, frame: CGRect(x: 58, y: 396, width: 257, height: 58))
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
        make.top.equalToSuperview().offset(100)
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
        sender.setShadows()
    }
    
    func setdefault(Email: String, Password: String, Logged: Bool){
        self.defaults.set(Email, forKey: "email")
        self.defaults.set(Password, forKey: "password")
        self.defaults.set(Logged, forKey: "logged")
    }
    
    @objc func buttonClicked(sender : UIButton) {
        sender.layer.sublayers?.removeFirst(2)
        showSpinner(onView: scrollView)
        
        let Password = password.text
        let Email = email.text
        let Confirm = confirm.text
        let Name = name.text

        let password_check = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$")
        let email_checker = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let email_check = NSPredicate(format: "SELF MATCHES %@ ", email_checker)
        
        if Password == "" || Email == "" || Confirm == "" || Name == ""{
            warning.text =  NSLocalizedString("You've entered an empty value", comment: "")
            removeSpinner()
            scrollView.addSubview(warning)
            AddConstraints(view: warning, top: 456, height: 58, width: 257)
        }
        else{
            if password_check.evaluate(with: Password) == true && email_check.evaluate(with: Email) == true && Password == Confirm
            {
                let hashedPassword = ("\(Password!).\(Email!)").sha256()

                register(email: Email!, password: hashedPassword, name: Name!){result in
                    if result == "Signed up!"{
                        self.setdefault(Email: Email!, Password: hashedPassword, Logged: true)
                        self.defaults.set(self.name.text, forKey: "name")
                        
                        let vc = RootViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                    else if result == "User exists!"{
                        self.warning.textColor = .red
                        self.warning.text = NSLocalizedString("User with the same email already excists! Please Log In", comment: "")
                        removeSpinner()
                        self.scrollView.addSubview(self.warning)
                        AddConstraints(view: self.warning, top: 456, height: 58, width: 257)
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
                AddConstraints(view: warning, top: 456, height: 58, width: 257)
            }
            else if Password != Confirm{
                warning.text = NSLocalizedString("Passwords are not equal", comment: "")
                removeSpinner()
                scrollView.addSubview(warning)
                AddConstraints(view: warning, top: 456, height: 58, width: 257)
            }
            else {
                warning.text = NSLocalizedString("This email address doesn't exist", comment: "")
                removeSpinner()
                scrollView.addSubview(warning)
                AddConstraints(view: warning, top: 456, height: 58, width: 257)
            }
        }
    }
}

public func register(email: String, password: String, name: String, with completion: @escaping (String) -> ()){
    let url = URL(string: "https://recipe-finder-api-nodejs.herokuapp.com/register")!

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    // Set HTTP Request Headers
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let newUser = [
        "email": "\(email)",
        "password": "\(password)",
        "name": "\(name)"
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
                    print(result)
                    completion(result)
                }
            }
        }
    }.resume()
}
