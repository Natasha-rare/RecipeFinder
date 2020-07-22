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

public func FetchUser(){
    let defaults = UserDefaults.standard
    let email1 = defaults.string(forKey: "email") ?? "Nope"
    let password1 = defaults.string(forKey: "password") ?? "Nope"
    let url =  "https://recipe-finder-api-nodejs.herokuapp.com/?email=\(email1)&password=\(password1)"
    AF.request(url).responseDecodable(of: User.self){
        (response) in
        guard let user = response.value else{return}
        print(user)
    }
}

public func ChangeUserInfo(user: User){
    let url =  "https://recipe-finder-api-nodejs.herokuapp.com/"
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
