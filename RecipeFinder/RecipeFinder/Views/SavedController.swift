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
public var fullLinks: [Links] = []

class SavedController: UIViewController, UITableViewDataSource{
    
    let scrollView = UIScrollView()
    let label = UILabel()
    let buttonEnter = NeoButton()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        refresh()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)

        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = NSLocalizedString("Saved", comment: "")
        label.font = UIFont.systemFont(ofSize: 43, weight: .semibold)
        label.textAlignment = .center
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        buttonEnter.load(title: NSLocalizedString("clear all", comment: ""), frame: CGRect(x: 58, y: 589, width: 259, height: 58), color: UIColor(red: 216.0/255.0, green: 141.0/255.0, blue: 10.0/255.0, alpha: 1))
        buttonEnter.setTitleColor(.white, for: .normal)
        buttonEnter.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        buttonEnter.addTarget(self, action: #selector(self.buttonClicked1(sender:)), for: .touchDown)
        
        tableView.frame = CGRect(x: 8, y: 128, width: UIScreen.main.bounds.width - 16, height: UIScreen.main.bounds.height)
        tableView.register(TableViewCellS.self, forCellReuseIdentifier: "TableViewCellS")
        tableView.dataSource = self
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = 60
        
        
        tableView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(savedLinks.count * 60 + 100))
//         scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + CGFloat(savedLinks.count * 60))
        
        super.view.addSubview(label)
        AddConstraints(view: label, top: 28, height: 79, width: 375)
        
        tableView.addSubview(buttonEnter)
        AddConstraints(view: buttonEnter, top: 200 + savedLinks.count * 50, height: 58, width: 259)
        
        super.view.addSubview(tableView)
        
//        scrollView.addSubview(label)
//        AddConstraints(view: label, top: 28, height: 79, width: 375)
//
//        scrollView.addSubview(tableView)
//
//        scrollView.addSubview(buttonEnter)
//        AddConstraints(view: buttonEnter, top: 100 + savedLinks.count * 80, height: 58, width: 259)
//
//        super.view.addSubview(scrollView)
//        AddConstraints(view: scrollView, top: 0, height: Int(UIScreen.main.bounds.height + CGFloat(savedLinks.count * 60)), width:  Int(UIScreen.main.bounds.width))
    }
    
    @objc func refresh() {
        self.tableView.reloadData() // a refresh the tableView.
    }
    
//    @objc func imageTapped(_ sender: SaveButton) {
//        let vc = WebViewController()
//        vc.url = sender.url
//        self.present(vc, animated: true, completion: nil)
//    }
    
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
        print(fullLinks)
        var cell = TableViewCellS()
        cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellS", for: indexPath) as! TableViewCellS
        if fullLinks.count != 0{
            cell.recipe = fullLinks[indexPath.row]
            cell.textLabel?.text = ""
            cell.btn.titleLabel!.text = fullLinks[indexPath.row].url
            cell.btn.addTarget(self, action: #selector(presentWebBrowser(sender:)), for: .touchDown)
            cell.btn.frame = CGRect(x: 8, y: 1, width: 280, height: 30)
        }
        else{
            cell.textLabel?.text = savedLinks[indexPath.row]
            cell.btn.titleLabel!.text = savedLinks[indexPath.row]
            cell.btn.addTarget(self, action: #selector(presentWebBrowser(sender:)), for: .touchDown)
            cell.btn.frame = CGRect(x: 8, y: 1, width: 280, height: 30)
            cell.layoutSubviews()}
        return cell
    }
    
    @objc func buttonClicked(sender : NeoButton) {
        sender.setShadows()
    }
    
    @objc func presentWebBrowser(sender: UIButton) {
            let vc = WebViewController()
            vc.url = sender.titleLabel?.text ?? "https://www.google.com"
            self.present(vc, animated: true, completion: nil)
        }

    @objc func buttonClicked1(sender : NeoButton) {
        sender.layer.sublayers?.removeFirst(2)
        fullLinks = []
        defaults.removeObject(forKey: "recipeUrls")
        defaults.removeObject(forKey: "recipeImages")
        defaults.removeObject(forKey: "recipeNames")
         self.tableView.reloadData()
        SendLinks(savedLinks: fullLinks)
    }
    
}

class TableViewCellS: TableViewCell {
    var recipe : Links? {
    didSet {
        let data = try? Data(contentsOf: URL(string: recipe!.imageUrl)!)
        
        if let imageData = data {
            recipeImageUrl.image = UIImage(data: imageData)!
        }
        
        recipeUrl.text = recipe?.url
        recipeNameLabel.text = recipe?.name
    }
    }
    
    private let recipeNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let recipeUrl : UILabel = {
    let lbl = UILabel()
    lbl.textColor = .black
    lbl.font = UIFont.systemFont(ofSize: 16)
    lbl.textAlignment = .left
    lbl.numberOfLines = 0
    return lbl
    }()
    
    private let recipeImageUrl : UIImageView = {
        let imgView = UIImageView(image: UIImage(named:""))
    imgView.contentMode = .scaleAspectFit
    imgView.clipsToBounds = true
    return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(recipeImageUrl)
        addSubview(recipeNameLabel)
        addSubview(btn)
        
        recipeImageUrl.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 60, height: 0, enableInsets: false)
        recipeNameLabel.anchor(top: topAnchor, left: recipeImageUrl.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: frame.size.width - 30, height: 0, enableInsets: false)
        btn.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 250, height: 20, enableInsets: false)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
                let images = data.savedRecipeImages?.components(separatedBy: "|")
                let urls = data.savedRecipeURLs?.components(separatedBy: "|")
                let names = data.savedRecipeNames?.components(separatedBy: "|")
                if let res = images{
                    for i in 0 ..< res.count {
                        fullLinks.append(Links(url: urls![i], imageUrl: images![i], name: names![i]))
                    }
                    defaults.set(images, forKey: "recipeImages")
                    defaults.set(urls, forKey: "recipeUrls")
                    defaults.set(names, forKey: "recipeNames")
                }
                else{
                    fullLinks = []
                }
                self.tableView.reloadData()
            }
        }
    }
}
