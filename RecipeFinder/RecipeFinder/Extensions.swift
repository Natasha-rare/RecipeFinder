//
//  NeomorphicShadow.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/13/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class GrayTextField: UITextField{
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadField(placeholderText: "", isSecure: false, frame: CGRect(x: 58, y: 536, width: 257, height: 58))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadField(placeholderText: String, isSecure: Bool, frame: CGRect){
        backgroundColor = UIColor(red: 0.892, green: 0.892, blue: 0.892, alpha: 1)
        attributedPlaceholder = NSAttributedString(string: "  \(placeholderText)",
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1)])
        self.frame = frame
        textColor = UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1)
        font = UIFont(name: "Harmattan-Regular", size: 27)
        textAlignment = .center
        layer.cornerRadius = 35.0
        isSecureTextEntry = isSecure
    }
}

class NeoButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        load(title: "Hi", frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(title: String, frame: CGRect, color: UIColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)){
        
        setTitle("\(title)", for: .normal)
        setTitleColor(UIColor.black, for: .normal)
        self.frame = frame
        backgroundColor = color
        layer.cornerRadius = 35.0
        
        let lightShadow = CALayer()
        lightShadow.frame = self.bounds
        lightShadow.backgroundColor = self.backgroundColor?.cgColor
        lightShadow.shadowColor = UIColor.white.withAlphaComponent(1).cgColor
        lightShadow.cornerRadius = 35
        lightShadow.shadowOffset = CGSize(width: -10, height: -10)
        lightShadow.shadowOpacity = 1
        lightShadow.shadowRadius = 7
        
        let darkShadow = CALayer()
        darkShadow.frame = self.bounds
        darkShadow.backgroundColor = self.backgroundColor?.cgColor
        darkShadow.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        darkShadow.cornerRadius = 35
        darkShadow.shadowOffset = CGSize(width: 10, height: 10)
        darkShadow.shadowOpacity = 1
        darkShadow.shadowRadius = 10
        
        self.layer.insertSublayer(lightShadow, at: 1)
        self.layer.insertSublayer(darkShadow, at: 0)
    }
    
}


extension ProfileController{
    func FetchUserData(){
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "email") ?? "Nope"
        let password = defaults.string(forKey: "password") ?? "Nope"
        let url =  "https://recipe-finder-api.azurewebsites.net/?email=\(email)&pass=\(password)"
        let request = AF.request(url)
        request.responseDecodable(of: User.self){
            (response) in
            guard let user = response.value else{return}
            self.greeting.text = "Hello, \(user.name ?? "Chef")"
            self.email.text = "Your email: \(user.email)"
        }
       
    }
}

extension HomeController{
    func getRecipes(ingridients: [String]){
        //optimizing string for request
        var string: String = ""
        for i in ingridients{
            string += i + "%20"
        }
        let url = "https://api.edamam.com/search?q=\(string)&app_id=ff10aa7b&app_key=2cc3b582558c8fa5ec04b81d34c537b1"
        AF.request(url).responseDecodable(of: Welcome.self){
            response in
            guard let recipes = response.value else {return}
            print(recipes.hits[0].recipe.label)
            self.label2.text = recipes.hits[0].recipe.label
        }
    }
}
