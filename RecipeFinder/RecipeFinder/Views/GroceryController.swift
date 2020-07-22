import UIKit
import Alamofire

public var groceryIngridients: [String] = []


class GroceryController: UIViewController{
    var label = UILabel()
    var scrollView = UIScrollView()
    var buttonEnter = NeoButton()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        super.viewDidLoad()
        fetchIngredients{
            res in
            print(res)
            groceryIngridients = res
        }
        
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
        print(groceryIngridients)
        
        for ingredient in groceryIngridients{
            let label2 = UILabel()
            label2.text = ingredient
            label2.frame = CGRect(x: 80, y: 140 + groceryIngridients.firstIndex(of: ingredient)! * 50, width: 240, height: 50)
            label2.textColor = UIColor.systemGray
            
            let image = UIImageView(image: UIImage(named: "check-box.png"))
            image.frame = CGRect(x: 56, y: 155 + groceryIngridients.firstIndex(of: ingredient)! * 50, width: 20, height: 20)
            image.tintColor = UIColor.black
            
            scrollView.addSubview(image)
            ImageConstraints(view: image, top: 155 + groceryIngridients.firstIndex(of: ingredient)! * 50, width: 20, height: 20, left: 56)
            
            scrollView.addSubview(label2)
            AddConstraints(view: label2, top: 140 + groceryIngridients.firstIndex(of: ingredient)! * 50, height: 50, width: 240)
        }
        
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
        groceryIngridients = []
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
