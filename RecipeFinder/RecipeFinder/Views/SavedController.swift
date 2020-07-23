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

class SavedController: UIViewController, UITableViewDataSource{
    
    let scrollView = UIScrollView()
    let label = UILabel()
    let buttonEnter = NeoButton()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        
        fetchLinks()
        print(savedLinks)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)

        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Saved"
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        
//        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(savedLinks.count * 80 + 330))
        
        buttonEnter.load(title: "clear all", frame: CGRect(x: 58, y: 589, width: 259, height: 58), color: UIColor(red: 216.0/255.0, green: 141.0/255.0, blue: 10.0/255.0, alpha: 1))
        buttonEnter.setTitleColor(.white, for: .normal)
        buttonEnter.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        buttonEnter.addTarget(self, action: #selector(self.buttonClicked1(sender:)), for: .touchDown)
        
        tableView.frame = CGRect(x: 0, y: 128, width: Int(UIScreen.main.bounds.width), height: Int(UIScreen.main.bounds.height))
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.backgroundColor = view.backgroundColor
        tableView.rowHeight = UITableView.automaticDimension
        
//        tableView.estimatedRowHeight = 100
        
        var count = 0
        for url in savedLinks {
            let imageV = SaveButton()
            
            imageV.load(title: url, frame: CGRect(x: 10,y: 128 + count * 80, width: 290, height: 62), url: url)
            imageV.addTarget(self, action: #selector(self.imageTapped(_:)), for: .touchUpInside)
            
            scrollView.addSubview(imageV)
            AddConstraints(view: imageV, top: 128 + count * 80, height: 62, width: 290)
            
            count += 1
        }
        tableView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(savedLinks.count * 80 + 100))
        
        super.view.addSubview(label)
        AddConstraints(view: label, top: 28, height: 79, width: 375)
        
        tableView.addSubview(buttonEnter)
        AddConstraints(view: buttonEnter, top: 200 + count * 30, height: 58, width: 259)
        
        
        super.view.addSubview(tableView)
        
//        super.view.addSubview(scrollView)
//        ScrollViewConstraints(view: scrollView)
        
    }
    
    @objc func refresh() {

        self.tableView.reloadData() // a refresh the tableView.

    }
    
    @objc func imageTapped(_ sender: SaveButton) {
        let vc = WebViewController()
        vc.url = sender.url
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tableView:
           return savedLinks.count
         default:
           return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = TableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.textLabel?.text = savedLinks[indexPath.row]
        cell.btn.titleLabel!.text = savedLinks[indexPath.row]
        cell.btn.addTarget(self, action: #selector(presentWebBrowser(sender:)), for: .touchDown)
        cell.layoutSubviews()
        print(savedLinks[indexPath.row])
        return cell
    }
    
    @objc func buttonClicked(sender : NeoButton) {
        sender.setShadows()
    }
    
    @objc func presentWebBrowser(sender: UIButton) {
            print("fs")
            let vc = WebViewController()
            vc.url = sender.titleLabel?.text! as! String
            self.present(vc, animated: true, completion: nil)
    //        print("tapped")
        }

    @objc func buttonClicked1(sender : NeoButton) {
        savedLinks = []
        
         self.tableView.reloadData()
        SendLinks(savedLinks: savedLinks)
    }
    
}

class TableViewCell: UITableViewCell {
    
    
    let btn = UIButton()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let imageView = UIImageView(image: UIImage(named: "link.png"))
        imageView.frame = CGRect(x: 10, y: 16, width: 20, height: 20)
        self.addSubview(imageView)
        
        ImageConstraints(view: imageView, top: 10, width: 20, height: 20, left: 5)

        self.textLabel!.translatesAutoresizingMaskIntoConstraints = false
        textLabel!.textColor = .black
        textLabel!.font = UIFont(name: "Harmattan-Regular", size: 18)
//        textLabel!.frame = CGRect(x: 40, y: 10, width: 200, height: 30)
        textLabel?.textRect(forBounds: CGRect(x: 0, y: 0, width: 180, height: 30), limitedToNumberOfLines: 2)
        self.addSubview(textLabel!)
        textLabel!.leftAnchor.constraint(equalTo: self.imageView!.rightAnchor).isActive = true
        textLabel!.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textLabel!.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textLabel!.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textLabel?.leftAnchor.constraint(equalTo: self.imageView!.leftAnchor, constant: 40)
        
        self.addSubview(btn)
        AddConstraints(view: btn, top: 5, height: 30, width: 200)
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
                    savedLinks = value
                }
                
            }
        }
    }
}
