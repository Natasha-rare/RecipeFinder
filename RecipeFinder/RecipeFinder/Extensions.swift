//
//  NeomorphicShadow.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/13/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit

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
        layer.cornerRadius = 35.0
        isSecureTextEntry = isSecure
    }
}

class NeoButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        load(title: "Hi", frame: CGRect(x: 58, y: 643, width: 257, height: 58))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(title: String, frame: CGRect){
        
        setTitle("\(title)", for: .normal)
        setTitleColor(UIColor.black, for: .normal)
        self.frame = frame
        backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        layer.cornerRadius = 35.0
        
        let lightShadow = CALayer()
        lightShadow.frame = self.bounds
        lightShadow.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1).cgColor
        lightShadow.shadowColor = UIColor.white.withAlphaComponent(1).cgColor
        lightShadow.cornerRadius = 35
        lightShadow.shadowOffset = CGSize(width: -10, height: -10)
        lightShadow.shadowOpacity = 1
        lightShadow.shadowRadius = 30
        
        let darkShadow = CALayer()
        darkShadow.frame = self.bounds
        darkShadow.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1).cgColor
        darkShadow.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        darkShadow.cornerRadius = 35
        darkShadow.shadowOffset = CGSize(width: 10, height: 10)
        darkShadow.shadowOpacity = 1
        darkShadow.shadowRadius = 30
        
        self.layer.insertSublayer(lightShadow, at: 0)
        self.layer.insertSublayer(darkShadow, at: 1)
    }
}
