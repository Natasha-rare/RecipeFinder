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
    var savedLinks: [Link]?
    var productList: [Products]?
    
}

public struct Products: Codable {
    var product: String?
    var amount: Double?
}

public struct Link: Codable {
    var address: String?
}

public var GlobalUser = User(name: "", email: "", password: "", savedLinks: nil, productList: nil)

public func FetchUser(with completion: @escaping (User) -> ()){
    let defaults = UserDefaults.standard
    let email = defaults.string(forKey: "email") ?? "Nope"
    let password = defaults.string(forKey: "password") ?? "Nope"
    let url =  "https://recipe-finder-api.azurewebsites.net/?email=\(email)&pass=\(password)"
    AF.request(url).responseDecodable(of: User.self){
        (response) in
        guard let user = response.value else{return}
        completion(user)
    }
}

public func ChangeUserInfo(user: User){
    let url =  "https://recipe-finder-api.azurewebsites.net/"
    let params = user.dictionary
    AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default).response{
        response in
        print(response)
    }
}

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
