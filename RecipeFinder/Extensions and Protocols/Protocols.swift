//
//  Protocols.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/17/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation

protocol RecipeArrayDelegate: AnyObject {
    func getIngridients(_ array: [String])
}
