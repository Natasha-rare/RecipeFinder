//
//  UserModel.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/9/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import Alamofire
public struct User: Codable {
    var name: String?
    var email: String?
    var password: String?
    var savedLinks: String?
    var productList: String?
}

let defaults = UserDefaults.standard


public func SendLinks(savedLinks: [String]){
    let url =  "https://recipe-finder-api-nodejs.herokuapp.com/"
    
    let email = defaults.string(forKey: "email") ?? "Nope"
    let password = defaults.string(forKey: "password") ?? "Nope"
    
    let preparedString = savedLinks.joined(separator: "|")
    print(preparedString)
    let params = [
        "email": "\(email)",
        "password": "\(password)",
        "savedLinks": "\(preparedString)"
    ]
    AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default).response{
        response in
        if let string = response.value{
            print("Send links response: \(string)")
        }
        
    }
}

public func SendIngredients(ingredientList: [String]){
    let url =  "https://recipe-finder-api-nodejs.herokuapp.com/"
    
    let email = defaults.string(forKey: "email") ?? "Nope"
    let password = defaults.string(forKey: "password") ?? "Nope"
    
    let preparedString = ingredientList.joined(separator: "|")
    let params = [
        "email": "\(email)",
        "password": "\(password)",
        "productList": "\(preparedString)"
    ]
    AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default).response{
        response in
        if let string = response.value{
            print("Ingredient send response: \(string)")
        }
        
    }
}

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
