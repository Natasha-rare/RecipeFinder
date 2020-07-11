//
//  RegistrationController.swift
//  RecipeFinder
//
//  Created by I on 10.07.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit
class RegistrationController: UIViewController{
    var warning = UILabel()
    var email = UITextField()
    var label = UILabel()
    var password = UITextField()
    var name = UITextField()
    var confirm = UITextField()
    var buttonCreate = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect(x: 3, y: 85, width: 370, height: 53)
        label.textColor = UIColor.blue
        label.text = "Registration"
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textAlignment = .center
        super.view.addSubview(label)
        
        email.backgroundColor = .lightGray
        email.attributedPlaceholder = NSAttributedString(string: "   Email",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        email.frame = CGRect(x: 49, y: 200, width: 270, height: 40)
        email.textColor = .white
        email.layer.cornerRadius = 15.0
        email.layer.borderWidth = 2.0
        email.layer.borderColor = UIColor.lightGray.cgColor
        
        password.backgroundColor = .lightGray
        password.attributedPlaceholder = NSAttributedString(string: "   Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        password.isSecureTextEntry = true
        password.frame = CGRect(x: 49, y: 250, width: 270, height: 40)
        password.textColor = .white
        password.layer.cornerRadius = 15.0
        password.layer.borderWidth = 2.0
        password.layer.borderColor = UIColor.lightGray.cgColor
        
        confirm.backgroundColor = .lightGray
        confirm.attributedPlaceholder = NSAttributedString(string: "   Confirm password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        confirm.frame = CGRect(x: 49, y: 300, width: 270, height: 40)
        password.isSecureTextEntry = true
        confirm.textColor = .white
        confirm.layer.cornerRadius = 15.0
        confirm.layer.borderWidth = 2.0
        confirm.layer.borderColor = UIColor.lightGray.cgColor
        
        name.backgroundColor = .lightGray
        name.attributedPlaceholder = NSAttributedString(string: "   Your name",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        name.frame = CGRect(x: 49, y: 350, width: 270, height: 40)
        name.textColor = .white
        name.layer.cornerRadius = 15.0
        name.layer.borderWidth = 2.0
        name.layer.borderColor = UIColor.lightGray.cgColor
        
        buttonCreate.setTitle("Ready to cook", for: .normal)
        buttonCreate.setTitleColor(UIColor.white, for: .normal)
        buttonCreate.backgroundColor = .systemPink
        buttonCreate.frame = CGRect(x: 47, y: 520, width: 274, height: 77)
        buttonCreate.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        buttonCreate.layer.cornerRadius = 15.0
        buttonCreate.layer.borderWidth = 2.0
        buttonCreate.layer.borderColor = UIColor.systemPink.cgColor
        
        warning.text = "Password should contain capital, lowercase letters and numbers"
        warning.frame = CGRect(x: 10, y: 400, width: 350, height: 60)
        warning.textColor = UIColor.red
        warning.font = UIFont.systemFont(ofSize: 18, weight: .thin)
        warning.numberOfLines = 2
        warning.textAlignment = .center
        super.view.addSubview(buttonCreate)
        super.view.addSubview(email)
        super.view.addSubview(password)
        super.view.addSubview(confirm)
        super.view.addSubview(name)
    }
    @objc func buttonClicked(sender : UIButton) {
           let Password = password.text
           let Email = email.text
           let Confirm = confirm.text
           let Name = name.text
           print("Password : \(Password ?? ""), Email: \(Email ?? "")")
           //var url_text =  "https://recipe-finder-api.azurewebsites.net?email=" + Email! ?? "" + "&pass=" + Password!
           //let url = URL(string: url_text)
           //print(url)
           let password_check = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$")
           let email_checker = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
           let email_check = NSPredicate(format: "SELF MATCHES %@ ", email_checker)
           if Password == "" || Email == "" || Confirm == "" || Name == ""{
               warning.text = "You've entered an empry value"
               super.view.addSubview(warning)
           }
           else{
               if password_check.evaluate(with: Password) == true && email_check.evaluate(with: Email) == true && Password == Confirm
               {
                   print("Password right, email right")
                   let vc = RootViewController()
                   vc.modalPresentationStyle = .fullScreen
                   self.present(vc, animated: true, completion: nil)
                   print("Button1 Clicked")
                   
               }
               else if password_check.evaluate(with: Password) == false
               {
                   print("Password wrong")
                   if Password!.count < 8 {
                       warning.text = "Your password is too short"
                   }
                   else {
                       warning.text = "Password should contain capital, lowercase letters and numbers"
                   }
                   super.view.addSubview(warning)
               }
               else if Password != Confirm{
                   print("Passwords are not equal")
                   warning.text = "Passwords are not equal"
                   super.view.addSubview(warning)
               }
               else {
                   print("Email wrong")
                   warning.text = "This email adress doesn't exist"
                   super.view.addSubview(warning)
               }
           }
       }
}
