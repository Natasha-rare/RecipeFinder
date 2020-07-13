//
//  NeomorphicShadow.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/13/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit

extension CALayer{
    public func darkShadow(button: UIButton){
        self.frame = button.bounds
        self.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1).cgColor
        self.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.cornerRadius = 35
        self.shadowOffset = CGSize(width: 10, height: 10)
        self.shadowOpacity = 1
        self.shadowRadius = 30
    }
    public func lightShadow(button: UIButton){
        self.frame = button.bounds
        self.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1).cgColor
        self.shadowColor = UIColor.white.withAlphaComponent(1).cgColor
        self.cornerRadius = 35
        self.shadowOffset = CGSize(width: -10, height: -10)
        self.shadowOpacity = 1
        self.shadowRadius = 30
    }
}
