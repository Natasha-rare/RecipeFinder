//
//  TextController.swift
//  RecipeFinder
//
//  Created by Наталья Автухович on 14.07.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit

class TextController: UIViewController, UITextFieldDelegate
{
    var label = UILabel()
    var label2 = UILabel()
    var buttonDone = NeoButton()
    var textSearch = GrayTextField()
    var buttonHasBeenPressed = false
    var productsList: [String] = []
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
        
        let search = UIImage(named: "search.png")
        let searchView = UIImageView(image: search)
        searchView.frame = CGRect(x: 49, y: 373, width: 30, height: 30)
        
        super.view.addSubview(buttonDone)
        super.view.addSubview(label)
        super.view.addSubview(label2)
        super.view.addSubview(searchView)
        super.view.addSubview(textSearch)
    }
    
    @objc func buttonClicked(sender: NeoButton){
        let vc = HomeController()
        vc.label2.text = "Hi!"
        //self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonGo(_ sender: Any) {
           performAction()
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

