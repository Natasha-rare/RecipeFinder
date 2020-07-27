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
        
        tableView.frame = CGRect(x: 8, y: 128, width: UIScreen.main.bounds.width - 16, height: UIScreen.main.bounds.height)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableView.automaticDimension
        
        
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
        AddConstraints(view: buttonEnter, top: 300 + count * 30, height: 58, width: 259)
        
        
        super.view.addSubview(tableView)
        
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            savedLinks.remove(at: indexPath.row)
            print(savedLinks)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } 
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = TableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.textLabel?.text = savedLinks[indexPath.row]
        cell.textLabel?.frame = CGRect(x: 60, y: 5, width: Int(UIScreen.main.bounds.width - 76), height: 30)
        cell.btn.titleLabel!.text = savedLinks[indexPath.row]
        cell.btn.addTarget(self, action: #selector(presentWebBrowser(sender:)), for: .touchDown)
        cell.btn.frame = CGRect(x: 8, y: 1, width: 280, height: 30)
        cell.layoutSubviews()
        print(savedLinks[indexPath.row])
        return cell
    }
    
    @objc func buttonClicked(sender : NeoButton) {
        sender.setShadows()
    }
    
    @objc func presentWebBrowser(sender: UIButton) {
            let vc = WebViewController()
            vc.url = sender.titleLabel?.text! as! String
            self.present(vc, animated: true, completion: nil)
        }

    @objc func buttonClicked1(sender : NeoButton) {
        sender.layer.sublayers?.removeFirst(2)
        savedLinks = []
        
         self.tableView.reloadData()
        SendLinks(savedLinks: savedLinks)
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
                    self.tableView.reloadData()
                }
                
            }
        }
    }
}
