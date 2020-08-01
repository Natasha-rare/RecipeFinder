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
    let buttonEnter = UIButton(type: .custom)
    let tableView = UITableView()
    
    override func viewDidLoad() {
        
        if(fullLinks.count != 0){
            if(fullLinks[0].url == ""){
                fullLinks.remove(at: 0)
            }
        }
        
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
        
        buttonEnter.frame = CGRect(x: UIScreen.main.bounds.width - 100, y: 620, width: 60, height: 60)
//        buttonEnter.setTitle("Clear All", for: .normal)
        buttonEnter.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        buttonEnter.clipsToBounds = true
        buttonEnter.layer.cornerRadius = 30
        buttonEnter.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        buttonEnter.layer.borderWidth = 1.0
        buttonEnter.setImage(UIImage(named: "trash-2"), for: .normal)
//        buttonEnter.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        buttonEnter.addTarget(self, action: #selector(self.buttonClicked1(sender:)), for: .touchUpInside)
        
        
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
        label.snp.makeConstraints { (make) -> Void in
        make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(79)
        make.width.equalToSuperview().offset(20)
        }
        
//        tableView.addSubview(buttonEnter)
//        AddConstraints(view: buttonEnter, top: 100 + savedLinks.count * 50, height: 100, width: 100)
        super.view.addSubview(tableView)
        super.view.addSubview(buttonEnter)
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        buttonEnter.removeFromSuperview()
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
           return fullLinks.count
         default:
           return 0
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fullLinks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            SendLinks(savedLinks: fullLinks)
            var names = [String]()
            var imgs = [String]()
            var urls = [String]()
            for i in fullLinks{
                names.append(i.name)
                imgs.append(i.imageUrl)
                urls.append(i.url)
            }
            defaults.set(names, forKey: "recipeNames")
            defaults.set(imgs, forKey: "recipeImages")
            defaults.set(urls, forKey: "recipeUrls")
        } 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("\(fullLinks) FULLLINKS HEREEE")
        var cell = TableViewCellS()
        cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellS", for: indexPath) as! TableViewCellS
        cell.recipe = fullLinks[indexPath.row]
        cell.btn.titleLabel!.text = fullLinks[indexPath.row].url
        cell.btn.addTarget(self, action: #selector(presentWebBrowser(sender:)), for: .touchDown)
        cell.btn.frame = CGRect(x: 8, y: 1, width: 280, height: 30)
        return cell
    }
//
//    @objc func buttonClicked(sender : NeoButton) {
//        sender.setShadows()
//    }
    
    @objc func presentWebBrowser(sender: UIButton) {
            let vc = WebViewController()
            vc.url = sender.titleLabel?.text ?? "https://www.google.com"
            self.present(vc, animated: true, completion: nil)
        }

    @objc func buttonClicked1(sender : NeoButton) {
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
        btn.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 250, height: 0, enableInsets: false)
    
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
