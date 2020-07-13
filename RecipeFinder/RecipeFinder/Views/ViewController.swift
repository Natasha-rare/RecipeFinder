//
//  ViewController.swift
//  RecipeFinder
//
//  Created by Наталья Автухович on 08.07.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    var label = UILabel()
    var label2 = UILabel()
    var email = UITextField()
    var password = UITextField()
    var buttonStart = UIButton()
    var buttonRegistr = UIButton()
    var image = UIImage(named: "image 1.jpg")
    var warning =  UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1).cgColor
        
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
//        label.backgroundColor = .white
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Recipe Finder"
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        
        label2.frame = CGRect(x: 45, y: 104, width: 286, height: 83)
//        label2.backgroundColor = .white
        label2.textColor = UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1)
        label2.font = UIFont(name: "Harmattan-Regular", size: 30)
        label2.numberOfLines = 0
        label2.lineBreakMode = .byWordWrapping
        label2.text = "Enter your products. We’ll show you the recipe"
        label2.textAlignment = .center
        
        email.backgroundColor = UIColor(red: 0.892, green: 0.892, blue: 0.892, alpha: 1)
        email.attributedPlaceholder = NSAttributedString(string: "  Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1)])
        email.frame = CGRect(x: 58, y: 468, width: 257, height: 58)
        email.textColor = UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1)
        email.font = UIFont(name: "Harmattan-Regular", size: 27)
        email.layer.cornerRadius = 35.0
//        email.layer.cornerRadius = 15.0
//        email.layer.borderWidth = 2.0
//        email.layer.borderColor = UIColor.lightGray.cgColor
        
        password.backgroundColor = UIColor(red: 0.892, green: 0.892, blue: 0.892, alpha: 1)
        password.attributedPlaceholder = NSAttributedString(string: "  Password",
           attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1)])
        password.frame = CGRect(x: 58, y: 536, width: 257, height: 58)
        password.textColor = UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1)
        password.font = UIFont(name: "Harmattan-Regular", size: 27)
        password.layer.cornerRadius = 35.0
        password.isSecureTextEntry = true
        
        warning.text = "Password should contain capital, lowercase letters and numbers"
        warning.frame = CGRect(x: 10, y: 390, width: 350, height: 60)
        warning.textColor = UIColor.red
        warning.font = UIFont.systemFont(ofSize: 18, weight: .thin)
        warning.numberOfLines = 2
        warning.textAlignment = .center
        
        buttonStart.setTitle("Let's go", for: .normal)
        buttonStart.setTitleColor(UIColor.black, for: .normal)
        buttonStart.frame = CGRect(x: 58, y: 643, width: 257, height: 58)
        buttonStart.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        buttonStart.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        buttonStart.layer.cornerRadius = 35.0
        
       
        let shadow = CALayer()
        shadow.darkShadow(button: buttonStart)
        buttonStart.layer.insertSublayer(shadow, at: 0)

        let anotherShadow = CALayer()
        anotherShadw.lightShadow(button: buttonStart)
        buttonStart.layer.insertSublayer(anotherShadow, at: 0)

        
        buttonRegistr.setTitle("Don’t have an account?", for: .normal)
        buttonRegistr.setTitleColor(UIColor(red: 0.604, green: 0.604, blue: 0.604, alpha: 1), for: .normal)
        buttonRegistr.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        buttonRegistr.frame = CGRect(x: 0, y: 750, width: 375, height: 33)
        buttonRegistr.addTarget(self, action: #selector(self.buttonRegistr(sender:)), for: .touchUpInside)
        
        let image = UIImage(named: "image 1.jpg")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 95, y: 216, width: 185, height: 185)
        
        super.view.addSubview(label)
        super.view.addSubview(label2)
        super.view.addSubview(email)
        super.view.addSubview(password)
        super.view.addSubview(imageView)
        super.view.addSubview(buttonStart)
        super.view.addSubview(buttonRegistr)
    }
    
    @objc func buttonClicked(sender : UIButton) {
        let Password = password.text
        let Email = email.text
        //print("Password : \(Password ?? ""), Email: \(Email ?? "")")
        //var url_text =  "https://recipe-finder-api.azurewebsites.net?email=" + Email! ?? "" + "&pass=" + Password!
        //let url = URL(string: url_text)
        //print(url)
        let password_check = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$")
        let email_checker = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let email_check = NSPredicate(format: "SELF MATCHES %@ ", email_checker)
        if Password == "" || Email == ""{
            warning.text = "You've entered an empty value"
            super.view.addSubview(warning)
        }
        else{
            if password_check.evaluate(with: Password) == true && email_check.evaluate(with: Email) == true
                {
                
                auth(email: email.text!, password: password.text!){
                    result in
                    print(result)
                    if result == "\"Logged in!\""{
                        let vc = RootViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                    else if result == "\"Incorrect password!\""{
                        self.warning.text = "Incorrect password :("
                        super.view.addSubview(self.warning)
                    }
                    else{
                        self.warning.textColor = .red
                        self.warning.text = "Hey! Seems you have to register!"
                        super.view.addSubview(self.warning)
                    }
                }
                
            }
            else if password_check.evaluate(with: Password) == false
            {
                //print("Password wrong")
                if Password!.count < 8 {
                    warning.text = "Your password is too short"
                }
                else {
                    warning.text = "Password should contain capital, lowercase letters and numbers"
                }
                super.view.addSubview(warning)
            }
            else {
                //print("Email wrong")
                warning.text = "This email address doesn't exist"
                super.view.addSubview(warning)
            }
        }
    }
    
    @objc func buttonRegistr(sender : UIButton) {
        let viewc = RegistrationController()
        self.present(viewc, animated: true, completion: nil)
        //print("Button2 Clicked")
    }
}


public func auth(email: String, password: String, with completion: @escaping (String) -> ()){
    let url = URL(string: "https://recipe-finder-api.azurewebsites.net")!
    
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

