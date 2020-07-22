//
//  SavedViewController.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/10/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

public var savedLinks: [String] = []

class SavedController: UIViewController{
    
    let scrollView = UIScrollView()
    let label = UILabel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        fetchLinks()
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Saved"
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(savedLinks.count * 80 + 200))
        var count = 0
        for url in savedLinks {
            let imageV = SaveButton()
            
            imageV.load(title: url, frame: CGRect(x: 10,y: 128 + count * 80, width: 290, height: 62), url: url)
            imageV.addTarget(self, action: #selector(self.imageTapped(_:)), for: .touchUpInside)
            
            scrollView.addSubview(imageV)
            AddConstraints(view: imageV, top: 128 + count * 80, height: 62, width: 290)
            
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
    
    func load(title: String, frame: CGRect, color: UIColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1), url: String, imageFrame: CGRect = CGRect(x: 10, y: 16, width: 30, height: 30)){
        
        self.url = url
        let label = UILabel()
        label.text = title
        label.textColor = .black
        label.frame = CGRect(x: 48, y: 0, width: Int(frame.width) - 50, height: Int(frame.height))
        label.font = UIFont(name: "Harmattan-Regular", size: 18)
        
        let imageView = UIImageView(image: UIImage(named: "link.png"))
        imageView.frame = imageFrame
        
        self.frame = frame
        backgroundColor = color
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 0.5
        
        self.addSubview(label)
        self.addSubview(imageView)
    }
}

extension SavedController{
    func fetchLinks(){
        let email = defaults.string(forKey: "email") ?? "Nope"
        let password = defaults.string(forKey: "password") ?? "Nope"
        let url =  "https://recipe-finder-api-nodejs.herokuapp.com/?email=\(email)&password=\(password)"
        AF.request(url).responseDecodable(of: User.self){
            (response) in
            if let data = response.value{
                if let value = data.savedLinks?.components(separatedBy: "|"){
                    print(value)
                    savedLinks = value
                }
                
            }
        }
    }
}
