import UIKit
import Alamofire

public var groceryIngridients: [String] = []


class GroceryController: UIViewController, UITableViewDataSource{
    
    
    var label = UILabel()
    var scrollView = UIScrollView()
    var buttonEnter = UIButton()
    var tableView = UITableView()
    
    override func viewDidLoad() {
        
        if(groceryIngridients.count != 0){
            if(groceryIngridients[0] == ""){
                groceryIngridients.remove(at: 0)
            }
        }
        
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        super.viewDidLoad()
        refresh()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        
        tableView.frame = CGRect(x: 8, y: 128, width: UIScreen.main.bounds.width - 16, height: UIScreen.main.bounds.height)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: .zero)
//        tableView.rowHeight = 35
        
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text =  NSLocalizedString("Grocery", comment: "")
        label.font = UIFont.systemFont(ofSize: 43, weight: .semibold)
        label.textAlignment = .center
        
        buttonEnter.frame = CGRect(x: UIScreen.main.bounds.width - 100, y: 620, width: 60, height: 60)
//        buttonEnter.setTitle("Clear All", for: .normal)
        buttonEnter.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        buttonEnter.clipsToBounds = true
        buttonEnter.layer.cornerRadius = 30
        buttonEnter.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        buttonEnter.layer.borderWidth = 1.0
        buttonEnter.setImage(UIImage(named: "trash-2.png"), for: .normal)
        buttonEnter.addTarget(self, action: #selector(self.buttonClicked1(sender:)), for: .touchUpInside)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        print(groceryIngridients)
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(groceryIngridients.count * 50 + 330))
        
        
        super.view.addSubview(label)
        label.snp.makeConstraints { (make) -> Void in
        make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(79)
        make.width.equalToSuperview().offset(20)
        }
        
        super.view.addSubview(tableView)
        super.view.addSubview(buttonEnter)
        
    }
    
    @objc func refresh() {
        self.tableView.reloadData() // a refresh the tableView.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tableView:
           return groceryIngridients.count
         default:
           return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = TableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.textLabel?.text = groceryIngridients[indexPath.row]
        cell.btn.setImage(UIImage(named: "check-box.png"), for: .normal)
        cell.btn.layer.borderColor = UIColor.black.cgColor
        cell.btn.anchor(top: cell.topAnchor, left: cell.leftAnchor, bottom: cell.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 25, height: 0, enableInsets: false)
        cell.textLabel!.anchor(top: cell.topAnchor, left: cell.btn.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: CGFloat(UIScreen.main.bounds.width - 76), height: 0, enableInsets: false)
//        cell.textLabel?.frame = CGRect(x: 60, y: 5, width: Int(UIScreen.main.bounds.width - 76), height: 30)
        cell.btn.addTarget(self, action: #selector(imageTapped(_:)), for: .touchDown)
        cell.layoutSubviews()
        return cell
    }

    @objc func buttonClicked1(sender : UIButton) {
        
        groceryIngridients = []
        defaults.removeObject(forKey: "grocery")
        self.tableView.reloadData()
        SendIngredients(ingredientList: groceryIngridients)
    
    }
    
    @objc func imageTapped(_ button: UIButton){
        if button.layer.borderColor == UIColor.black.cgColor{
            button.setImage(UIImage(named: "checked.png"), for: .normal)
            button.layer.borderColor = UIColor.white.cgColor
        }
        else{
            button.setImage(UIImage(named: "check-box.png"), for: .normal)
            button.layer.borderColor = UIColor.black.cgColor
        }
    }

}

extension GroceryController{
    func fetchIngredients(competionHandler: @escaping ([String]) -> ()){
        let email = defaults.string(forKey: "email") ?? "Nope"
        let password = defaults.string(forKey: "password") ?? "Nope"
        let url =  "https://recipe-finder-api-nodejs.herokuapp.com/?email=\(email)&password=\(password)"
        AF.request(url).responseDecodable(of: User.self){
            (response) in
            if let data = response.value{
                
                if let value = data.productList?.components(separatedBy: "|"){
                    competionHandler(value)
                }
            }
        }
    }
}
