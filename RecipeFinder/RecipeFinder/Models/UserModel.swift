//
//  UserModel.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/9/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation

public struct User: Codable {
    var id: Int
    var name: String
    var email: String
    var SavedLinks: [Link]
    var ProductList: [Products]
}

public struct Products: Codable {
    var id: Int
    var product: String
    var amount: Double
}

public struct Link: Codable {
    var id: Int
    var address: String
}
