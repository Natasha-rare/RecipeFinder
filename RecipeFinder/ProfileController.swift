//
//  ProfileController.swift
//  RecipeFinder
//
//  Created by I on 10.07.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit
class ProfileController: UIViewController{
    var buttonExit = NeoButton()
    let label = UILabel()
    var name = UILabel()
    var email = UILabel()
    var password = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Profile"
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        
        let image = UIImage(named: "user.png")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 128, y: 139, width: 117, height: 117)
        
        
        
        buttonExit.load(title: "log out", frame: CGRect(x: 58, y: 589, width: 259, height: 58))
        buttonExit.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        
        super.view.addSubview(label)
        super.view.addSubview(buttonExit)
        super.view.addSubview(imageView)
        
//        var urlString = "https://recipe-finder-api.azurewebsites.net?email=johnappleseed@ya.ru&pass=123"
    }
    
    @objc func buttonClicked(sender: UIButton){
        
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "logged")
        
        let vc = ViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        print("Button1 Clicked")
    }
    
    func FetchUserData(){
        let defaults = UserDefaults.standard
        
        let url = URL(string: "https://recipe-finder-api.azurewebsites.net/?email=\(String(describing: defaults.data(forKey: "email")))&pass=\(String(describing: defaults.data(forKey: "password")))")!
        
               URLSession.shared.dataTask(with: url){
                   data, response, error in
                   
                   if let data = data {
                       
                       if let decodedResponse = try? JSONDecoder().decode([User].self, from: data) {
                           // we have good data – go back to the main thread
                           DispatchQueue.main.async {
                               // update our UI
                            print(decodedResponse)
                               //self.user = decodedResponse
                           }

                           // everything is good, so we can exit
                           return
                       }
                   }
                   
               }.resume()
    }
}
