//
//  RecipeModel.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/14/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation

struct Welcome: Codable {
    let q: String
    let from, to: Int
    let more: Bool
    let count: Int
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe
    let bookmarked, bought: Bool
}

// MARK: - Recipe
struct Recipe: Codable {
    let uri: String
    let label: String
    let image: String
    let source: String
    let url: String
    let ingredientLines: [String]
}


