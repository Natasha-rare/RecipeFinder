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
        layer.cornerRadius = 30.0
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
        layer.cornerRadius = 30.0
        
        setShadows()
    }
    
    func setShadows(){
        let lightShadow = CALayer()
           lightShadow.frame = self.bounds
           lightShadow.backgroundColor = self.backgroundColor?.cgColor
           lightShadow.shadowColor = UIColor.white.withAlphaComponent(1).cgColor
           lightShadow.cornerRadius = 30
           lightShadow.shadowOffset = CGSize(width: -10, height: -10)
           lightShadow.shadowOpacity = 1
           lightShadow.shadowRadius = 7
               
       let darkShadow = CALayer()
           darkShadow.frame = self.bounds
           darkShadow.backgroundColor = self.backgroundColor?.cgColor
           darkShadow.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
           darkShadow.cornerRadius = 30
           darkShadow.shadowOffset = CGSize(width: 10, height: 10)
           darkShadow.shadowOpacity = 1
           darkShadow.shadowRadius = 10
               
       self.layer.insertSublayer(lightShadow, at: 1)
       self.layer.insertSublayer(darkShadow, at: 0)
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
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 680)
        
        scrollView.addSubview(label)
        AddConstraints(view: label, top: 28, height: 79, width: 375)
        
        scrollView.addSubview(label2)
        AddConstraints(view: label2, top: 200, height: 80, width: 259)
        
        scrollView.addSubview(buttonText)
        AddConstraints(view: buttonText, top: 333, height: 60, width: 168)
        
        scrollView.addSubview(buttonVoice)
        AddConstraints(view: buttonVoice, top: 433, height: 60, width: 168)
        
        scrollView.addSubview(buttonScan)
        AddConstraints(view: buttonScan, top: 533, height: 60, width: 168)
        
        scrollView.addSubview(cameraView)
        ImageConstraints(view: cameraView, top: 548, width: 30, height: 30, left: 62)
        
        scrollView.addSubview(textView)
        ImageConstraints(view: textView, top: 348, width: 30, height: 30, left: 62)
        
        scrollView.addSubview(voiceView)
        ImageConstraints(view: voiceView, top: 448, width: 30, height: 30, left: 62)
        
        super.view.addSubview(scrollView)
        ScrollViewConstraints(view: scrollView)
    }
    
    func loadViewWithCards(recipes: Welcome){
        var count: Int = 0
        
        label.frame = CGRect(x: 0, y: 5, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Home"
        label.font = UIFont(name: "Georgia", size: 43)
        
        label2.frame = CGRect(x: 60, y: 80, width: 256, height: 80)
        label2.textColor = UIColor(red: 0.604, green: 0.604, blue: 0.604, alpha: 1)
        label2.font = UIFont(name: "Harmattan-Regular", size: 20)
        label2.textAlignment = .center
        label2.numberOfLines = 2
        label2.lineBreakMode = .byWordWrapping
        label2.text =  "Ingredients: " + recipes.q + " "
        
//        print(recipes)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1000)
        
        let button = NeoButton()
        button.load(title: "Find other recipes", frame: CGRect(x: 60, y: 160, width: 256, height: 60))
        button.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        
        for hit in recipes.hits{
            let url = URL(string: hit.recipe.image)!
            let data = try? Data(contentsOf: url)
            var image = UIImage()
            
            if let imageData = data {
                image = UIImage(data: imageData)!
            }
            
            let imageV = CardImage()
            imageV.load(title: hit.recipe.label,frame: CGRect(x: 60, y: 270 + count * 280, width: 256, height: 256), image: image, url: hit.recipe.url)
            imageV.addTarget(self, action: #selector(self.imageTapped(sender:)), for: .touchUpInside)

            let button = LikeButton()
                button.frame = CGRect(x: 275, y: 285 + count * 280, width: 30, height: 30)
                button.setImage(UIImage(named: "like.png"), for: .normal)
                button.layer.cornerRadius = 10
                button.layer.masksToBounds = true
                button.url = hit.recipe.url
                button.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
            
            let buttonGrocery = UIButton()
                buttonGrocery.frame = CGRect(x: 75, y: 285 + count * 280, width: 30, height: 30)
                buttonGrocery.setImage(UIImage(named: "grocery.png"), for: .normal)
                buttonGrocery.layer.cornerRadius = 10
                buttonGrocery.layer.masksToBounds = true
                buttonGrocery.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
            
            scrollView.addSubview(imageV)
            AddConstraints(view: imageV, top: 270 + count * 280, height: 256, width: 256)
            
            scrollView.addSubview(button)
            ImageConstraints(view: button, top: 285 + count * 280, width: 30, height: 30, left: 275)
            
            scrollView.addSubview(buttonGrocery)
            ImageConstraints(view: buttonGrocery, top: 285 + count * 280, width: 30, height: 30, left: 75)
            
            count += 1
        }
        
        scrollView.contentSize.height = CGFloat(Float(count * 280 + 270))

        scrollView.addSubview(label)
        AddConstraints(view: label, top: 5, height: 79, width: 375)
        
        label2.text = label2.text!.lowercased()
        scrollView.addSubview(label2)
        AddConstraints(view: label2, top: 80, height: 80, width: 256)
        
        scrollView.addSubview(button)
        AddConstraints(view: button, top: 160, height: 60, width: 256)
        
        super.view.addSubview(scrollView)
        ScrollViewConstraints(view: scrollView)
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
        let originalImage = UIImage(named: "like.png")
        let tintedImage = originalImage?.withRenderingMode(.alwaysTemplate)
        
        sender.setImage(tintedImage, for: .normal)
        sender.tintColor = UIColor.red
        GlobalUser.savedLinks?.append(Link(address: sender.url))
    }

    @objc func groceryTapped(_ sender: UIButton){
        // ingridients to groery
    }
}

class LikeButton: UIButton{
    var url: String = ""
}

public var vSpinner: UIView?

public func showSpinner(onView : UIView) {
    let spinnerView = UIView.init(frame: onView.bounds)
    spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    let ai = UIActivityIndicatorView.init(style: .whiteLarge)
    ai.startAnimating()
    ai.center = spinnerView.center
    
    DispatchQueue.main.async {
        spinnerView.addSubview(ai)
        onView.addSubview(spinnerView)
    }
    
    vSpinner = spinnerView
}

public func removeSpinner() {
    DispatchQueue.main.async {
        vSpinner?.removeFromSuperview()
        vSpinner = nil
    }
}
