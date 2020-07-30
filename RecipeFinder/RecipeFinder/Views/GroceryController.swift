import UIKit
import Alamofire

public var groceryIngridients: [String] = []


class GroceryController: UIViewController, UITableViewDataSource{
    
    
    var label = UILabel()
    var scrollView = UIScrollView()
    var buttonEnter = NeoButton()
    var tableView = UITableView()
    
    override func viewDidLoad() {
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
        
        buttonEnter.load(title: NSLocalizedString("clear all", comment: ""), frame: CGRect(x: 58, y: 589, width: 259, height: 58), color: UIColor(red: 216.0/255.0, green: 141.0/255.0, blue: 10.0/255.0, alpha: 1))
        buttonEnter.setTitleColor(.white, for: .normal)
        buttonEnter.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        buttonEnter.addTarget(self, action: #selector(self.buttonClicked1(sender:)), for: .touchDown)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        print(groceryIngridients)
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(groceryIngridients.count * 50 + 330))
        
        
        super.view.addSubview(label)
        AddConstraints(view: label, top: 28, height: 79, width: 375)
        
        tableView.addSubview(buttonEnter)
        AddConstraints(view: buttonEnter, top: 200 + groceryIngridients.count * 30, height: 58, width: 259)
        
        super.view.addSubview(tableView)
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
//        cell.textLabel?.frame = CGRect(x: 60, y: 5, width: Int(UIScreen.main.bounds.width - 76), height: 30)
        cell.btn.addTarget(self, action: #selector(imageTapped(_:)), for: .touchDown)
        cell.layoutSubviews()
        return cell
    }
    
    @objc func buttonClicked(sender : NeoButton) {
        sender.setShadows()
    }

    @objc func buttonClicked1(sender : NeoButton) {
        sender.layer.sublayers?.removeFirst(2)
        groceryIngridients = []
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
