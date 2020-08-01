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
import AVFoundation
import AudioToolbox

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
        font = UIFont.systemFont(ofSize: 27, weight: .regular)
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
        text.font = UIFont.systemFont(ofSize: 24, weight: .medium)
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
        label.text = NSLocalizedString("Home", comment: "")
        label.font = UIFont.systemFont(ofSize: 43, weight: .semibold)
        label.textAlignment = .center
        
        label2.frame = CGRect(x: 58, y: 200, width: 0.8 * scrollView.contentSize.width, height: 79)
        label2.textColor = UIColor(red: 0.604, green: 0.604, blue: 0.604, alpha: 1)
        label2.text = NSLocalizedString("It seems that you didn’t enter ingridients!", comment: "")
        label2.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label2.textAlignment = .center
        label2.numberOfLines = 0
        label2.lineBreakMode = .byWordWrapping
        
        buttonText.load(title: NSLocalizedString("text", comment: ""), frame: CGRect(x: 144, y: 333, width: UIScreen.main.bounds.width * 0.50, height: 60))
        buttonVoice.load(title: NSLocalizedString("voice", comment: ""), frame: CGRect(x: 144, y: 433, width: UIScreen.main.bounds.width * 0.50, height: 60))
        buttonScan.load(title: NSLocalizedString("camera", comment: ""), frame: CGRect(x: 144, y: 533, width: UIScreen.main.bounds.width * 0.50, height: 60))
        
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
        // тут не делал функцию потому что top равна superview
        label.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(50)
                make.centerX.equalToSuperview()
                make.height.equalTo(79)
            make.width.equalToSuperview().offset(20)
            }
        
        scrollView.addSubview(label2)
        MakeConstraints(view: label2, topView: label, topViewOffset: 30, height: 79, multipliedWidth: 0.80)
        
        scrollView.addSubview(buttonText)
        MakeConstraints(view: buttonText, topView: label2, topViewOffset: 50, height: 60, multipliedWidth: 0.50)
        
        scrollView.addSubview(buttonVoice)
        MakeConstraints(view: buttonVoice, topView: buttonText, topViewOffset: 50, height: 60, multipliedWidth: 0.50)
        
        scrollView.addSubview(buttonScan)
        MakeConstraints(view: buttonScan, topView: buttonVoice, topViewOffset: 50, height: 60, multipliedWidth: 0.50)
        
        
        
        
        scrollView.addSubview(textView)
        textView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(label2.snp.bottom).offset(60)
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.right.equalTo(buttonText.snp.left).offset(-30)
        }

        scrollView.addSubview(voiceView)
        voiceView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(textView.snp.bottom).offset(80)
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.right.equalTo(buttonVoice.snp.left).offset(-30)
        }
        
        scrollView.addSubview(cameraView)
        cameraView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(voiceView.snp.bottom).offset(90)
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.right.equalTo(buttonScan.snp.left).offset(-30)
        }
        
        super.view.addSubview(scrollView)
        ScrollViewConstraints(view: scrollView)
    }
    
    func loadViewWithCards(recipes: Welcome){
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        var count: Int = 0
        label.frame = CGRect(x: 0, y: 5, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Home"
        label.font = UIFont.systemFont(ofSize: 43, weight: .semibold)
        
        label2.frame = CGRect(x: 60, y: 80, width: 259, height: 79)
        label2.textColor = UIColor(red: 0.604, green: 0.604, blue: 0.604, alpha: 1)
        label2.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label2.textAlignment = .center
        label2.numberOfLines = 2
        label2.lineBreakMode = .byWordWrapping
        label2.text =  NSLocalizedString("Ingredients", comment: "") + ": "  + recipes.q + " "
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1000)
        
        let button = NeoButton()
        button.load(title: NSLocalizedString("Find other recipes", comment: ""), frame: CGRect(x: 60, y: 160, width: 256, height: 60))
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
                button.imageUrl = hit.recipe.image
                button.name = hit.recipe.label
                button.addTarget(self, action: #selector(self.likeButtonTapped(_:)), for: .touchUpInside)
            if savedLinks.contains(hit.recipe.url) {
                let originalImage = UIImage(named: "like.png")
                let tintedImage = originalImage?.withRenderingMode(.alwaysTemplate)
                button.setImage(tintedImage, for: .normal)
                button.tintColor = UIColor.red
            }
            let buttonGrocery = GroceryButton()
                buttonGrocery.frame = CGRect(x: 75, y: 285 + count * 280, width: 30, height: 30)
                buttonGrocery.setImage(UIImage(named: "grocery.png"), for: .normal)
                buttonGrocery.layer.cornerRadius = 10
                buttonGrocery.layer.masksToBounds = true
                buttonGrocery.ingredientList = hit.recipe.ingredientLines
                buttonGrocery.addTarget(self, action: #selector(self.groceryTapped(_:)), for: .touchUpInside)
            
            imageV.addSubview(button)
            ImageConstraints(view: button, top: 5, width: 30, height: 30, left: 221)
            
            imageV.addSubview(buttonGrocery)
            ImageConstraints(view: buttonGrocery, top: 5, width: 30, height: 30, left: 5)
            
            
            scrollView.addSubview(imageV)
            AddConstraints(view: imageV, top: 270 + count * 280, height: 256, width: 256)
            
            count += 1
        }
        
        scrollView.contentSize.height = CGFloat(Float(count * 280 + 270))

        scrollView.addSubview(label)
        AddConstraints(view: label, top: 5, height: 79, width: 375)
        
        label2.text = label2.text!.lowercased()
        scrollView.addSubview(label2)
        AddConstraints(view: label2, top: 80, height: 79, width: 259)
        
        scrollView.addSubview(button)
        AddConstraints(view: button, top: 160, height: 60, width: 256)
        
        super.view.addSubview(scrollView)
        ScrollViewConstraints(view: scrollView)
    }
    
    @objc func buttonPressed(){
        let vc = RootViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
        vc.selectedIndex = 0
    }

    @objc func imageTapped(_ sender: CardImage) {
        let vc = WebViewController()
        vc.url = sender.urlIm
        self.present(vc, animated: true, completion: nil)
    }
    
    func vibrate(){
           AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
       }
    
    @objc func likeButtonTapped(_ sender: LikeButton){
       print(sender.url)
        vibrate()
        let originalImage = sender.image(for: .normal)
        let tintedImage = originalImage?.withRenderingMode(.alwaysTemplate)
        sender.setImage(tintedImage, for: .normal)
        if sender.tintColor == UIColor.red{
            sender.tintColor = UIColor.white
            sender.setImage(UIImage(named: "like.png"), for: .normal)
            let savedLinksNew = fullLinks.filter { $0.url != sender.url }
            fullLinks = savedLinksNew
        }
        else{
            sender.tintColor = UIColor.red
            fullLinks.append(Links(url: sender.url, imageUrl: sender.imageUrl, name: sender.name))
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        // write array to user defaults here...
        var names = [String]()
        var imgs = [String]()
        var urls = [String]()
        for i in fullLinks{
            names.append(i.name)
            imgs.append(i.imageUrl)
            urls.append(i.url)
        }
        defaults.set(names, forKey: "recipeNames")
        defaults.set(imgs, forKey: "recipeImages")
        defaults.set(urls, forKey: "recipeUrls")
        SendLinks(savedLinks: fullLinks)
    }

    @objc func groceryTapped(_ sender: GroceryButton){
        vibrate()
        let originalImage = sender.image(for: .normal)
        let tintedImage = originalImage?.withRenderingMode(.alwaysTemplate)
        sender.setImage(tintedImage, for: .normal)
        if sender.tintColor == UIColor(red: 0.847, green: 0.553, blue: 0.039, alpha: 1){
            sender.tintColor = UIColor.white
            sender.setImage(UIImage(named: "grocery.png"), for: .normal)
            for ingredient in sender.ingredientList{
                groceryIngridients = groceryIngridients.filter {$0 != ingredient}
            }
        }
        else{
            sender.tintColor = UIColor(red: 0.847, green: 0.553, blue: 0.039, alpha: 1)
            // ingridients to grocery
            groceryIngridients = sender.ingredientList
        }
        
        defaults.set(groceryIngridients, forKey: "grocery")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        SendIngredients(ingredientList: groceryIngridients)
    }
}

class LikeButton: UIButton{
    var url: String = ""
    var imageUrl: String = ""
    var name: String = ""
}

class GroceryButton: UIButton{
    var ingredientList: [String] = []
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


public class TableViewCell: UITableViewCell {
    
    
    let btn = UIButton()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        
//        self.textLabel!.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel!.textColor = .black
        textLabel!.font = UIFont.boldSystemFont(ofSize: 16)
        textLabel!.textAlignment = .left
//        ImageConstraints(view: textLabel!, top: 5, width: Int(self.bounds.width - 76), height: 30, left: 76)
        
//        btn.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        self.addSubview(textLabel!)
        self.addSubview(btn)
        
        
//        ImageConstraints(view: btn, top: 5, width: 30, height: 30, left: 5)
    }
    
}



class SaveButton: UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
        load(title: "Hi", frame: frame, url: "")
    }
    
    var url = ""
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(title: String, frame: CGRect, color: UIColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1), url: String, imageFrame: CGRect = CGRect(x: 10, y: 16, width: 30, height: 30)){
        
        self.url = url
        let label = UILabel()
        label.text = title
        label.textColor = .black
        label.frame = CGRect(x: 48, y: 0, width: Int(frame.width) - 50, height: Int(frame.height))
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        let imageView = UIImageView(image: UIImage(named: "link.png"))
        imageView.frame = imageFrame
        
        self.frame = frame
        backgroundColor = color
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 0.5
        
        self.addSubview(label)
        self.addSubview(imageView)
    }
}


extension UIViewController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

extension UIView {
    
    func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        
        if #available(iOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
            
            print("Top: \(topInset)")
            print("bottom: \(bottomInset)")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
    }
    
}
