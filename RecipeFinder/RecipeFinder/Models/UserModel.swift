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
    var id: Int?
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

public var GlobalUser = User(id: 0, name: "", email: "", password: "", savedLinks: nil, productList: nil)

public func FetchUser(with completion: @escaping (User) -> ()){
    let defaults = UserDefaults.standard
    let email = defaults.string(forKey: "email") ?? "Nope"
    let password = defaults.string(forKey: "password") ?? "Nope"
    print(email)
    print(password)
    let url =  "https://recipe-finder-api.azurewebsites.net/?email=\(email)&pass=\(password)"
    AF.request(url).responseDecodable(of: User.self){
        (response) in
        guard let user = response.value else{return}
        completion(user)
    }
}

public func ChangeUserInfo(user: User){
    
}

