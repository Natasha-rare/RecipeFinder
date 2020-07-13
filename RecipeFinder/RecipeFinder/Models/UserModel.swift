//
//  UserModel.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/9/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation

struct User: Identifiable, Codable {
    var id: Int
    var name: String
    var email: String
    var SavedLinks: [Link]
    var ProductList: [Products]
}

struct Products: Identifiable, Codable {
    var id: Int
    var product: String
    var amount: Double
}

struct Link: Identifiable, Codable {
    var id: Int
    var address: String
}
