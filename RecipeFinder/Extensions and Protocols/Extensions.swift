//
//  NeomorphicShadow.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/13/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class GrayTextField: UITextField{
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadField(placeholderText: "", isSecure: false, frame: CGRect(x: 58, y: 536, width: 257, height: 58))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadField(placeholderText: String, isSecure: Bool, frame: CGRect){
        backgroundColor = UIColor(red: 0.892, green: 0.892, blue: 0.892, alpha: 1)
        attributedPlaceholder = NSAttributedString(string: "  \(placeholderText)",
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1)])
        self.frame = frame
        textColor = UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1)
        font = UIFont(name: "Harmattan-Regular", size: 27)
        textAlignment = .center
        layer.cornerRadius = 35.0
        isSecureTextEntry = isSecure
    }
}

class CardImage: UIButton{
    
    var title = ""
    var frameText = CGRect()
    var frameLab = CGRect()
    var urlIm = ""
    var image = UIImage()
    override init(frame: CGRect) {
        super.init(frame: frame)
        load(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(title: String = "", frame: CGRect, image: UIImage = UIImage(), frame_lab: CGRect = CGRect(x: 6, y: 180, width: 244, height: 66), frame_text: CGRect = CGRect(x: 45, y: 180, width: 180, height: 66), url:String = ""){
        
        self.urlIm = url
        self.title = title
        self.frameText = frame_text
        self.frameLab = frame_lab
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        layer.shadowOffset = CGSize(width: 10, height: 10)
        layer.shadowRadius = 10
        layer.shadowOpacity = 1
        setImage(image, for: .normal)
        
        self.frame = frame
        setShadows()
    }
    
    func setShadows(){
        let lightShadow = CALayer()
            lightShadow.frame = self.bounds
            lightShadow.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1).cgColor
            lightShadow.shadowColor = UIColor.white.withAlphaComponent(1).cgColor
            lightShadow.cornerRadius = 10
            lightShadow.shadowOffset = CGSize(width: -10, height: -10)
            lightShadow.shadowOpacity = 1
            lightShadow.shadowRadius = 10

        let darkShadow = CALayer()
            darkShadow.frame = self.bounds
            darkShadow.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1).cgColor
            darkShadow.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            darkShadow.cornerRadius = 10
            darkShadow.shadowOffset = CGSize(width: 10, height: 10)
            darkShadow.shadowOpacity = 1
            darkShadow.shadowRadius = 10

        let im = CALayer()
        let myImage = self.image.cgImage
            im.frame = self.bounds
            im.cornerRadius = 10
            im.contents = myImage
        im.masksToBounds = true
        
        let label = UILabel()
            label.frame = self.frameLab
            label.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
            label.layer.cornerRadius = 10
            label.layer.masksToBounds = true
        
        let text = UILabel()
            text.frame = self.frameText
            text.textColor = UIColor.white
            text.text = self.title
            text.font = UIFont(name: "Harmattan-Regular", size: 24)
            text.textAlignment = .left
        
        
//        layer.insertSublayer(lightShadow, at: 1)
//        layer.insertSublayer(darkShadow, at: 0)
//        layer.insertSublayer(im, at: 2)
//        self.setImage(image, for: .normal)
//        self.layer.masksToBounds = true
        self.addSubview(label)
        self.addSubview(text)
    }
    
}


class NeoButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        load(title: "Hi", frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(title: String, frame: CGRect, color: UIColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)){
        
        setTitle("\(title)", for: .normal)
        setTitleColor(UIColor.black, for: .normal)
        self.frame = frame
        backgroundColor = color
        layer.cornerRadius = 35.0
        
        setShadows()
        
    }
    func setShadows(){
        let lightShadow = CALayer()
           lightShadow.frame = self.bounds
           lightShadow.backgroundColor = self.backgroundColor?.cgColor
           lightShadow.shadowColor = UIColor.white.withAlphaComponent(1).cgColor
           lightShadow.cornerRadius = 35
           lightShadow.shadowOffset = CGSize(width: -10, height: -10)
           lightShadow.shadowOpacity = 1
           lightShadow.shadowRadius = 7
               
       let darkShadow = CALayer()
           darkShadow.frame = self.bounds
           darkShadow.backgroundColor = self.backgroundColor?.cgColor
           darkShadow.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
           darkShadow.cornerRadius = 35
           darkShadow.shadowOffset = CGSize(width: 10, height: 10)
           darkShadow.shadowOpacity = 1
           darkShadow.shadowRadius = 10
               
       self.layer.insertSublayer(lightShadow, at: 1)
       self.layer.insertSublayer(darkShadow, at: 0)
    }
    
}


extension ProfileController{
    func FetchUserData(){
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "email") ?? "Nope"
        let password = defaults.string(forKey: "password") ?? "Nope"
        let url =  "https://recipe-finder-api.azurewebsites.net/?email=\(email)&pass=\(password)"
        let request = AF.request(url)
        request.responseDecodable(of: User.self){
            (response) in
            guard let user = response.value else{return}
            self.greeting.text = "Hello, \(user.name ?? "Chef")"
            self.email.text = "Your email: \(user.email)"
        }
       
    }
}

extension HomeController{
    
    func loadViewWithoutCards(){
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Home"
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        
        label2.frame = CGRect(x: 58, y: 200, width: 259, height: 80)
        label2.textColor = UIColor(red: 0.604, green: 0.604, blue: 0.604, alpha: 1)
        label2.text = "It seems that you didn’t enter ingridients!"
        label2.font = UIFont(name: "Harmattan-Regular", size: 20)
        label2.textAlignment = .center
        label2.numberOfLines = 0
        label2.lineBreakMode = .byWordWrapping
        
        buttonText.load(title: "text", frame: CGRect(x: 144, y: 333, width: 168, height: 60))
        buttonVoice.load(title: "voice", frame: CGRect(x: 144, y: 433, width: 168, height: 60))
        buttonScan.load(title: "camera", frame: CGRect(x: 144, y: 533, width: 168, height: 60))
        
        buttonScan.addTarget(self, action: #selector(self.buttonRegistr(sender:)), for: .touchUpInside)
        buttonScan.addTarget(self, action: #selector(self.buttonRegistr2(sender:)), for: .touchDown)
        
        buttonVoice.addTarget(self, action: #selector(self.buttonVoice(sender:)), for: .touchUpInside)
        buttonVoice.addTarget(self, action: #selector(self.buttonVoice2(sender:)), for: .touchDown)
        
        buttonText.addTarget(self, action: #selector(self.buttonText(sender:)), for: .touchUpInside)
        buttonText.addTarget(self, action: #selector(self.buttonText2(sender:)), for: .touchDown)
        
        
        let camera = UIImage(named: "camera.png")
        let cameraView = UIImageView(image: camera)
        cameraView.frame = CGRect(x: 62, y: 548, width: 30, height: 30)
        
        let text = UIImage(named: "Text.png")
        let textView = UIImageView(image: text)
        textView.frame = CGRect(x: 62, y: 348, width: 30, height: 30)
        
        let voice = UIImage(named: "voice.png")
        let voiceView = UIImageView(image: voice)
        voiceView.frame = CGRect(x: 62, y: 448, width: 30, height: 30)
        
        
        super.view.addSubview(label)
        super.view.addSubview(label2)
        super.view.addSubview(buttonText)
        super.view.addSubview(buttonVoice)
        super.view.addSubview(buttonScan)
        super.view.addSubview(cameraView)
        super.view.addSubview(textView)
        super.view.addSubview(voiceView)
//
//        buttonScan.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            buttonScan.topAnchor
//                .constraint(equalTo: super.view.safeAreaLayoutGuide.topAnchor),
//            buttonScan.leftAnchor
//                .constraint(equalTo: super.view.safeAreaLayoutGuide.leftAnchor),
//            buttonScan.bottomAnchor
//                .constraint(equalTo: super.view.safeAreaLayoutGuide.bottomAnchor, constant: 593),
//            buttonScan.rightAnchor
//                .constraint(equalTo: super.view.safeAreaLayoutGuide.rightAnchor, constant: 312)
//        ])
//
    }
    
    
    func loadViewWithCards(recipes: Welcome){
        label.frame = CGRect(x: 0, y: 10, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Home"
        
        label2.frame = CGRect(x: 60, y: 80, width: 256, height: 80)
        label2.textColor = UIColor(red: 0.604, green: 0.604, blue: 0.604, alpha: 1)
        
        label2.font = UIFont(name: "Harmattan-Regular", size: 20)
        label2.textAlignment = .center
        label2.numberOfLines = 0
        label2.lineBreakMode = .byWordWrapping
        print(recipes)
        label.font = UIFont(name: "Georgia", size: 43)
        var count: Int = 0
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1000)
        let button = NeoButton()
        button.load(title: "Find other recipes", frame: CGRect(x: 60, y: 180, width: 256, height: 60))
        button.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        
        
        
        label2.text = "Your ingredients: " + recipes.q
        for hit in recipes.hits{
            let url = URL(string: hit.recipe.image)!
            let data = try? Data(contentsOf: url)
            var image = UIImage()
            if let imageData = data {
                image = UIImage(data: imageData)!
            }
            
            let imageV = CardImage()
            imageV.load(title: hit.recipe.label,frame: CGRect(x: 60, y: 300 + count * 280, width: 256, height: 256), image: image, url: hit.recipe.url)
            imageV.addTarget(self, action: #selector(self.imageTapped(sender:)), for: .touchUpInside)

            let button = LikeButton()
            button.frame = CGRect(x: 275, y: 315 + count * 280, width: 30, height: 30)
            button.setImage(UIImage(named: "like.png"), for: .normal)
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            button.url = hit.recipe.url
            button.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
            
            let buttonGrocery = UIButton()
            buttonGrocery.frame = CGRect(x: 75, y: 315 + count * 280, width: 30, height: 30)
            buttonGrocery.setImage(UIImage(named: "grocery.png"), for: .normal)
            
            buttonGrocery.layer.cornerRadius = 10
            buttonGrocery.layer.masksToBounds = true
            
            scrollView.addSubview(imageV)
            scrollView.addSubview(button)
            scrollView.addSubview(buttonGrocery)
            count += 1
        }
        
        scrollView.contentSize.height = CGFloat(Float(count * 280 + 300))

        scrollView.addSubview(label)
        scrollView.addSubview(label2)
        scrollView.addSubview(button)
        super.view.addSubview(scrollView)
    }
    @objc func buttonPressed(){
        let vc = HomeController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @objc func imageTapped(_ sender: CardImage) {
        let vc = WebViewController()
        vc.url = sender.urlIm
        self.present(vc, animated: true, completion: nil)
       }
    
    @objc func buttonTapped(_ sender: LikeButton){
        print(sender.url)
        let defaults = UserDefaults.standard
        let pass = defaults.object(forKey: "password")
        let email = defaults.object(forKey: "email")
        let name = defaults.object(forKey: "name")
        var arr: [Link] = []
        let url = URL(string: "https://recipe-finder-api.azurewebsites.net")!
        arr.append(Link(address: sender.url))
        let user = User(name: name as! String, email: email as! String, password: pass as? String, savedLinks: arr, productList: nil)
        AF.request(url,
                   method: .put,
                   parameters: try? JSONEncoder().encode(user)).response{response in
                    print(response)
        }
    }
}

class LikeButton: UIButton{
    var url: String = ""
}
