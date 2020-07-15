//
//  HomeControllerCell.swift
//  RecipeFinder
//
//  Created by Наталья Автухович on 15.07.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit

class HomeControllerCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var image = UIImageView()
    weak var name = UILabel()
    
}
