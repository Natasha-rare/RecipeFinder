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
            let data = try? Data(contentsOf: URL(string: url)!)
            var image = UIImage()
            
            if let imageData = data {
                image = UIImage(data: imageData)!
            }
            
            let imageV = CardImage()
            imageV.load(title: "",frame: CGRect(x: 60, y: 270 + count * 280, width: 256, height: 256), image: image, url: url)
            imageV.addTarget(self, action: #selector(self.imageTapped(_:)), for: .touchUpInside)
            
            scrollView.addSubview(imageV)
            AddConstraints(view: imageV, top: 270 + count * 280, height: 256, width: 256)
            
            count += 1
        }
    
        scrollView.addSubview(label)
        AddConstraints(view: label, top: 28, height: 79, width: 375)
        
        super.view.addSubview(scrollView)
        ScrollViewConstraints(view: scrollView)
        
    }
    
    @objc func imageTapped(_ sender: CardImage) {
        let vc = WebViewController()
        vc.url = sender.urlIm
        self.present(vc, animated: true, completion: nil)
    }
}
