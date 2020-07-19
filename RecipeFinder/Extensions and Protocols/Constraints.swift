//
//  Constraints.swift
//  RecipeFinder
//
//  Created by Наталья Автухович on 18.07.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

public func AddConstraints(view: UIView, top: Int, height: Int, width: Int){
    view.snp.makeConstraints { (make) -> Void in
        make.top.equalTo(top)
        make.centerX.equalToSuperview()
        make.height.equalTo(height)
        make.width.equalTo(width)
    }
}
    
public func ImageConstraints(view: UIView, top: Int, width: Int, height: Int, left: Int){
    view.snp.makeConstraints { (make) -> Void in
        make.top.equalTo(top)
//        make.centerX.equalToSuperview()
        make.height.equalTo(height)
        make.width.equalTo(width)
        make.left.equalTo(left)
    }
}

public func ScrollViewConstraints(view: UIScrollView){
    view.translatesAutoresizingMaskIntoConstraints = false
    view.snp.makeConstraints{(make) -> Void in
        make.top.equalToSuperview()
        make.left.equalToSuperview()
        make.bottom.equalToSuperview()
        make.right.equalToSuperview()
    }
//    NSLayoutConstraint.activate([
//        scrollView.topAnchor
//            .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//        scrollView.leftAnchor
//            .constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
//        scrollView.bottomAnchor
//            .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
//        scrollView.rightAnchor
//            .constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
//    ])
}

