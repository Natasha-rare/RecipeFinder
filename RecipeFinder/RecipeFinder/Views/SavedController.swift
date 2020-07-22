//
//  SavedViewController.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/10/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit


public var savedLinks: [String] = []

class SavedController: UIViewController{
    
    let scrollView = UIScrollView()
    let label = UILabel()
    
    
    //list from home

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Saved"
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        var count = 0
        print(savedLinks)
        for url in savedLinks {
            let imageV = SaveButton()
            imageV.load(title: url, frame: CGRect(x: 10,y: 150 + count * 60, width: 300, height: 50), url: url)
            imageV.setTitle(url, for: .normal)
            imageV.addTarget(self, action: #selector(self.imageTapped(_:)), for: .touchUpInside)
            
            scrollView.addSubview(imageV)
            AddConstraints(view: imageV, top: 150 + count * 60, height: 50, width: 300)
            
            count += 1
        }
    
        scrollView.addSubview(label)
        AddConstraints(view: label, top: 28, height: 79, width: 375)
        
        super.view.addSubview(scrollView)
        ScrollViewConstraints(view: scrollView)
        
    }
    
    @objc func imageTapped(_ sender: SaveButton) {
        let vc = WebViewController()
        vc.url = sender.url
        self.present(vc, animated: true, completion: nil)
    }
}

class SaveButton: UIButton{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        load(title: "Hi", frame: frame, url: "")
    }
    
    var url = ""
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(title: String, frame: CGRect, color: UIColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1), url: String){
        self.url = url
        setTitle("\(title)", for: .normal)
        setTitleColor(UIColor.black, for: .normal)
        self.frame = frame
        backgroundColor = color
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
    }
}
