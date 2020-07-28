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
    let scrollView = UIScrollView()
    let deleteAccountButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = NSLocalizedString("Profile", comment: "")
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        
        let image = UIImage(named: "user-1.png")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 128, y: 139, width: 117, height: 117)
        
        greeting.frame = CGRect(x: 61, y: 281, width: 257, height: 58)
        greeting.font = UIFont(name: "Harmattan-Regular", size: 24)
        greeting.textColor = UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1)
        greeting.textAlignment = .center
        greeting.text = NSLocalizedString("Hello", comment: "") + ", " + " \(defaults.object(forKey: "name") ?? "Chef")!"
        
        email.frame = CGRect(x: 61, y: 348, width: 257, height: 58)
        email.font = UIFont(name: "Harmattan-Regular", size: 24)
        email.textColor = UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1)
        email.textAlignment = .center
        email.text = defaults.string(forKey: "email")
        
        buttonExit.load(title: NSLocalizedString("log out", comment: ""), frame: CGRect(x: 102, y: 525, width: 170, height: 58), color: UIColor(red: 216.0/255.0, green: 141.0/255.0, blue: 10.0/255.0, alpha: 1))
        
        buttonExit.setTitleColor(.white, for: .normal)
        buttonExit.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        buttonExit.addTarget(self, action: #selector(self.buttonClicked2(sender:)), for: .touchDown)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 700)
    
        deleteAccountButton.frame = CGRect(x: 105, y: 420, width: 150, height: 50)
        deleteAccountButton.setTitle(NSLocalizedString("Delete account", comment: ""), for: .normal)
        deleteAccountButton.titleLabel?.font = UIFont(name: "Harmattan-Regular", size: 24)
        deleteAccountButton.setTitleColor(.red, for: .normal)
        deleteAccountButton.addTarget(self, action: #selector(self.deleteAccount(sender:)), for: .touchUpInside)
        
        scrollView.addSubview(deleteAccountButton)
        AddConstraints(view: deleteAccountButton, top: 420, height: 50, width: 150)
        
        scrollView.addSubview(label)
        AddConstraints(view: label, top: 28, height: 79, width: 375)
        
        scrollView.addSubview(buttonExit)
        AddConstraints(view: buttonExit, top: 525, height: 58, width: 170)
        
        scrollView.addSubview(imageView)
        AddConstraints(view: imageView, top: 139, height: 117, width: 117)
        
        scrollView.addSubview(greeting)
        AddConstraints(view: greeting, top: 281, height: 58, width: 257)
        
        scrollView.addSubview(email)
        AddConstraints(view: email, top: 348, height: 58, width: 257)
        
        super.view.addSubview(scrollView)
        ScrollViewConstraints(view: scrollView)
    }
    
    @objc func buttonClicked(sender: NeoButton){
        sender.setShadows()
        self.defaults.set(false, forKey: "logged")
        self.defaults.removeObject(forKey: "grocery")
        self.defaults.removeObject(forKey: "savedLinks")
        self.defaults.removeObject(forKey: "email")
        self.defaults.removeObject(forKey: "password")
        self.defaults.removeObject(forKey: "name")
        
        let vc = ViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func buttonClicked2(sender: NeoButton){
        sender.layer.sublayers?.removeFirst(2)
    }
    
    @objc func deleteAccount(sender: UIButton){
        let alert = UIAlertController(title: "Do you want to continue?", message: "By clicking 'yes' your account will be permanently deleted!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler:  {
                (action) -> Void in
            
            self.deleteAccountOnServer()
            self.defaults.set(false, forKey: "logged")
            self.defaults.removeObject(forKey: "grocery")
            self.defaults.removeObject(forKey: "savedLinks")
            self.defaults.removeObject(forKey: "email")
            self.defaults.removeObject(forKey: "password")
            self.defaults.removeObject(forKey: "name")
            
            let vc = ViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteAccountOnServer(){
        let url =  "https://recipe-finder-api-nodejs.herokuapp.com/"
        let email = defaults.string(forKey: "email") ?? "Nope"
        let password = defaults.string(forKey: "password") ?? "Nope"
        let params = [
            "email": "\(email)",
            "password": "\(password)"]
        AF.request(url, method: .delete, parameters: params, encoding: JSONEncoding.default).response{
            response in
            if let data = response.data{
                if let string = String(data: data, encoding: .utf8){
                    print("Delete account response: \(string)")
                }
            }
        }
    }
}
