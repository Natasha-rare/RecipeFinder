//
//  RegistrationController.swift
//  RecipeFinder
//
//  Created by I on 10.07.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit
import RNCryptor
import CryptoSwift
class RegistrationController: UIViewController{
    var warning = UILabel()
    var email = GrayTextField()
    var label = UILabel()
    var password = GrayTextField()
    var name = GrayTextField()
    var confirm = GrayTextField()
    var buttonCreate = NeoButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        view.layer.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1).cgColor
        
        
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Registration"
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        super.view.addSubview(label)
        
        
        name.loadField(placeholderText: "name", isSecure: false, frame: CGRect(x: 58, y: 152, width: 257, height: 58))
        
        email.loadField(placeholderText: "email", isSecure: false, frame: CGRect(x: 58, y: 240, width: 257, height: 58))
        
        password.loadField(placeholderText: "password", isSecure: false, frame: CGRect(x: 58, y: 318, width: 257, height: 58))
        
        confirm.loadField(placeholderText: "repeat password", isSecure: false, frame: CGRect(x: 58, y: 396, width: 257, height: 58))
        
        buttonCreate.load(title: "ready", frame: CGRect(x: 58, y: 516, width: 257, height: 58))
        buttonCreate.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        buttonCreate.addTarget(self, action: #selector(self.buttonClicked2(sender:)), for: .touchDown)
        
        warning.text = "Password should contain capital, lowercase letters and numbers"
        warning.frame = CGRect(x: 0, y: 456, width: 257, height: 58)
        warning.textColor = UIColor.red
        warning.font = UIFont.systemFont(ofSize: 18, weight: .thin)
        warning.numberOfLines = 0
        warning.lineBreakMode = .byWordWrapping
        warning.textAlignment = .center
        super.view.addSubview(buttonCreate)
        super.view.addSubview(email)
        super.view.addSubview(password)
        super.view.addSubview(confirm)
        super.view.addSubview(name)
    }
    @objc func buttonClicked2(sender : NeoButton){
        sender.setShadows()
    }
    func encrypt(plainText : String, password: String) -> String {
        
        let data: Data = plainText.data(using: .utf8)!
        let encryptedData = RNCryptor.encrypt(data: data, withPassword: encryptionKey)
        let encryptedString : String = encryptedData.base64EncodedString() // getting base64encoded string of encrypted data.
        return encryptedString
    }
    func decrypt(encryptedText : String, password: String) -> String {
        do  {
            let data: Data = Data(base64Encoded: encryptedText)! // Just get data from encrypted base64Encoded string.
            let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
            let decryptedString = String(data: decryptedData, encoding: .utf8) // Getting original string, using same .utf8 encoding option,which we used for encryption.
            return decryptedString ?? ""
        }
        catch {
            return "FAILED"
        }
    }
    @objc func buttonClicked(sender : UIButton) {
            sender.layer.sublayers?.removeFirst(2)
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
               warning.text = "You've entered an empty value"
               super.view.addSubview(warning)
           }
           else{
               if password_check.evaluate(with: Password) == true && email_check.evaluate(with: Email) == true && Password == Confirm
               {
                //let hashedPassword = encrypt(plainText: Password!, password: encryptionKEY)
                //print("HASHED:" + hashedPassword)
               // print(decrypt(encryptedText: hashedPassword, password: encryptionKEY))
                let hashedPassword = ("\(Password!).\(Email!)").sha256()
                print(hashedPassword)
                register(email: Email!, password: hashedPassword, name: Name!){result in
                    print(result)
                    if result == "\"Signed up!\""{
                        let vc = RootViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                    else if result == "\"User exists!\""{
                        self.warning.textColor = .red
                        self.warning.text = "User with the same email is already excist! Please Log In"
                        super.view.addSubview(self.warning)
                    }
                }
                   print("Password right, email right")
//                   let vc = RootViewController()
//                   vc.modalPresentationStyle = .fullScreen
//                   self.present(vc, animated: true, completion: nil)
//                   print("Button1 Clicked")

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
                   warning.text = "This email address doesn't exist"
                   super.view.addSubview(warning)
               }
           }
       }
    
}

public func register(email: String, password: String, name: String, with completion: @escaping (String) -> ()){
    let url = URL(string: "https://recipe-finder-api.azurewebsites.net/register")!

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
                    completion(result)
                }
            }
        }
        
    }.resume()
}
