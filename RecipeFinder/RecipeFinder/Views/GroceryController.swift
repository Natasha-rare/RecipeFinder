import UIKit


class GroceryController: UIViewController{
    var label = UILabel()

    var buttonEnter = NeoButton()
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Grocery"
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        
        buttonEnter.load(title: "clear all", frame: CGRect(x: 58, y: 589, width: 259, height: 58))
        buttonEnter.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        super.view.addSubview(label)
        super.view.addSubview(buttonEnter)
  }

    @objc func buttonClicked(sender : UIButton) {
        
    }
    
}
