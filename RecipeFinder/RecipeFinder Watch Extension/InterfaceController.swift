//
//  InterfaceController.swift
//  RecipeFinder Watch Extension
//
//  Created by I on 06.08.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import WatchKit
import Foundation
import CryptoKit
import Alamofire

class InterfaceController: WKInterfaceController {
    var Password : String = ""
    var Email : String = ""
    @IBAction func emailText(_ value: NSString?) {
        self.Email = value! as String
        print("E:", Email)
    }
    @IBAction func passwordText(_ value: NSString?) {
        self.Password = value! as String
        print("P:", Password)
    }
    @IBOutlet weak var email: WKInterfaceTextField!
    @IBOutlet weak var password: WKInterfaceTextField!
    @IBAction func buttonDonePressed() {
        Password = "123Password"
        Email = "janelake2017@gmail.com"
        let hash = "\(self.Password).\(self.Email)"
        let hashedPassword1 = SHA256.hash(data: Data(hash.utf8))
        let hashedPassword = hashedPassword1.map { String(format: "%02hhx", $0) }.joined()
        print("HASHED:", hashedPassword.description)
        UserDefaults.standard.set(false, forKey: "logged")
        print("HELLO:", UserDefaults.standard.bool(forKey: "logged"))
        let url = "https://recipe-finder-api-nodejs.herokuapp.com/?email=\(self.Email)&password=\(String(hashedPassword.description))"
        print(url)
        auth(email: Email, password: String(hashedPassword.description)) {
        result in
            print("heyheyhey")
            print("!", String(result))
        if result == "Logged in!"{
            let url = "https://recipe-finder-api-nodejs.herokuapp.com/?email=\(self.Email)&password=\(String(hashedPassword.description))"
            print(url)
            AF.request(url, method: .get).response{
                response in
                if let data = response.value{
                    print("next")
                    let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                        
                    if let dict = json as? [String: Any]{
                        print("gogogo")
                        print(dict["productList"] as! String)
                        UserDefaults.standard.set(dict["productList"] as! String, forKey: "productList")
                        UserDefaults.standard.set(true, forKey: "logged")
                        print("LOGGED:", UserDefaults.standard.bool(forKey: "logged"))
                        UserDefaults.standard.set(self.Email, forKey: "email")
                        UserDefaults.standard.set(String(hashedPassword.description), forKey: "password")
                        print(UserDefaults.standard.string(forKey: "productList") ?? "None")
                        self.presentController(withName: "Grocery", context: nil)
                        }
                    }
                }
            
            }
        else{
            print(String(result))
            }
        }
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print(UserDefaults.standard.bool(forKey: "logged"))
        if UserDefaults.standard.bool(forKey: "logged"){
            presentController(withName: "Grocery", context: nil)
        }
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    func auth(email: String, password: String, with completion: @escaping (String) -> ()){
            let url = URL(string: "https://recipe-finder-api-nodejs.herokuapp.com/login")!
            print("yes1")
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
            print("yo")
            URLSession.shared.dataTask(with: request){
                data, response, error in
                if let error = error {
                    print("Error! \(error)")
                }
                if let data = data{
                        print("go")
                    if let result = String(data: data, encoding: .utf8){
                        DispatchQueue.main.async {
                            print("aiaia")
                            completion(result)
                            print("zoo")
                        }
                    }
                }
                    
            }.resume()
                
        }

}

