//
//  TextController.swift
//  RecipeFinder
//
//  Created by Наталья Автухович on 14.07.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit

class TextController: UIViewController, UITextFieldDelegate{
    
    weak var delegate: RecipeArrayDelegate?
    
    var label = UILabel()
    var label2 = UILabel()
    var buttonDone = NeoButton()
    var textSearch = GrayTextField()
    var buttonHasBeenPressed = false
    var productsList: [String] = []
    var scrollView = UIScrollView()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
                
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
        
        textSearch.loadField(placeholderText: "input ingredients", isSecure: false, frame: CGRect(x: 97, y: 364, width: 225, height: 48))
        textSearch.delegate = self
        
        buttonDone.load(title: "done", frame: CGRect(x: 113, y: 584, width: 150, height: 58))
        buttonDone.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        buttonDone.addTarget(self, action: #selector(self.buttonClicked2(sender:)), for: .touchDown)
        
        let search = UIImage(named: "search.png")
        let searchView = UIImageView(image: search)
        searchView.frame = CGRect(x: 49, y: 373, width: 30, height: 30)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 650)
        
        scrollView.addSubview(buttonDone)
        AddConstraints(view: buttonDone, top: 584, height: 58, width: 150)
        
        scrollView.addSubview(label)
        AddConstraints(view: label, top: 28, height: 79, width: 375)
        
        scrollView.addSubview(label2)
        AddConstraints(view: label2, top: 200, height: 80, width: 259)
        
        scrollView.addSubview(searchView)
        ImageConstraints(view: searchView, top: 373, width: 30, height: 30, left: 49)
        
        scrollView.addSubview(textSearch)
        AddConstraints(view: textSearch, top: 364, height: 48, width: 225)
        
        super.view.addSubview(scrollView)
        ScrollViewConstraints(view: scrollView)
    }
    
    @objc func buttonClicked(sender: NeoButton){
        sender.setShadows()
        self.delegate?.getIngridients(productsList)
        self.dismiss(animated: true, completion: nil)
    }
    @objc func buttonClicked2(sender: NeoButton){
        sender.layer.sublayers?.removeFirst(2)
        self.delegate?.getIngridients(productsList)
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       performAction()
       return true
   }
  
   func performAction() {
        productsList.append(textSearch.text!.lowercased())
        if label2.text == "It seems that you didn’t enter ingridients!"{
           label2.text = textSearch.text!
        }
        else{
            label2.text! += ", \(textSearch.text!)"
        }
    
        textSearch.text = ""
   }
    
}

