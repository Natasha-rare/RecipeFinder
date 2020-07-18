import Foundation
import UIKit
import Alamofire
class ProfileController: UIViewController{
    var buttonExit = NeoButton()
    let label = UILabel()
    var name = UILabel()
    var email = UILabel()
    var password = UILabel()
    var greeting = UILabel()
    var defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Profile"
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        
        let image = UIImage(named: "user-1.png")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 128, y: 139, width: 117, height: 117)
        
        greeting.frame = CGRect(x: 61, y: 281, width: 257, height: 58)
        greeting.font = UIFont(name: "Harmattan-Regular", size: 24)
        greeting.textColor = UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1)
        greeting.textAlignment = .center
        greeting.text = "Hello, \(defaults.string(forKey: "name"))!"
        
        email.frame = CGRect(x: 61, y: 348, width: 257, height: 58)
        email.font = UIFont(name: "Harmattan-Regular", size: 24)
        email.textColor = UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1)
        email.textAlignment = .center
        email.text = defaults.string(forKey: "email")
        
        buttonExit.load(title: "log out", frame: CGRect(x: 102, y: 525, width: 170, height: 58), color: UIColor(red: 1, green: 0.562, blue: 0.562, alpha: 1))
        
        buttonExit.setTitleColor(.white, for: .normal)
        buttonExit.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        buttonExit.addTarget(self, action: #selector(self.buttonClicked2(sender:)), for: .touchDown)
        
        super.view.addSubview(label)
        super.view.addSubview(buttonExit)
        super.view.addSubview(imageView)
        super.view.addSubview(greeting)
        super.view.addSubview(email)
    }
    
    @objc func buttonClicked(sender: NeoButton){
        sender.setShadows()
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "logged")
        
        let vc = ViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        print("Button1 Clicked")
    }
    @objc func buttonClicked2(sender: NeoButton){
        sender.layer.sublayers?.removeFirst(2)
    }
}
