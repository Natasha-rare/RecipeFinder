import UIKit
import Alamofire

public var groceryIngridients: [String] = []


class GroceryController: UIViewController{
    var label = UILabel()
    var scrollView = UIScrollView()
    var buttonEnter = NeoButton()
    
    
    //list from home

    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        super.viewDidLoad()
        fetchIngredients()
        print(groceryIngridients)
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Grocery"
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        
        buttonEnter.load(title: "clear all", frame: CGRect(x: 58, y: 589, width: 259, height: 58), color: UIColor(red: 216.0/255.0, green: 141.0/255.0, blue: 10.0/255.0, alpha: 1))
        buttonEnter.setTitleColor(.white, for: .normal)
        buttonEnter.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        buttonEnter.addTarget(self, action: #selector(self.buttonClicked1(sender:)), for: .touchDown)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 700)
        
        scrollView.addSubview(label)
        AddConstraints(view: label, top: 28, height: 79, width: 375)
        
        scrollView.addSubview(buttonEnter)
        AddConstraints(view: buttonEnter, top: 589, height: 58, width: 259)
        
        super.view.addSubview(scrollView)
        ScrollViewConstraints(view: scrollView)
    }

    @objc func buttonClicked(sender : NeoButton) {
        sender.setShadows()
    }

    @objc func buttonClicked1(sender : NeoButton) {
        sender.layer.sublayers?.removeFirst(2)
    }

}

extension GroceryController{
    func fetchIngredients(){
        let email = defaults.string(forKey: "email") ?? "Nope"
        let password = defaults.string(forKey: "password") ?? "Nope"
        let url =  "https://recipe-finder-api-nodejs.herokuapp.com/?email=\(email)&password=\(password)"
        AF.request(url).responseDecodable(of: User.self){
            (response) in
            if let data = response.value{
                if let value = data.productList?.components(separatedBy: "|"){
                    print(value)
                    groceryIngridients = value
                }
                
            }
        }
    }
}
