//
//  HomeController.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/10/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit
import Speech
import Alamofire
class HomeController: UIViewController, RecipeArrayDelegate, UIGestureRecognizerDelegate{

    let label = UILabel()
    let label2 = UILabel()
    let buttonText = NeoButton()
    let buttonVoice = NeoButton()
    let buttonScan = NeoButton()
    var string: String = ""
    var checker = 0
//    let imageV = CardImage()
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var task: SFSpeechRecognitionTask!
    var isStart: Bool = false
    var timerForShowScrollIndicator = Timer()
    let cardViewEnabled: Bool = false
    var numberOfIngredient: Int = 0
    var rec = Welcome(q: "", from: 0, to: 0, more: false, count: 0, hits: [])
    var selectedImage: String = ""
    var scrollView = UIScrollView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        
        loadViewWithoutCards()
    }
    
    @objc func buttonRegistr(sender : NeoButton) {
        sender.setShadows()
        
        let viewc = ScanController()
        viewc.delegate = self
        self.present(viewc, animated: true, completion: nil)
    }
    
    @objc func buttonRegistr2(sender : NeoButton) {
        sender.layer.sublayers?.removeFirst(2)
    }
    
    @objc func imageTapped(sender: CardImage){
        let vc = WebViewController()
        vc.url = sender.urlIm
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func buttonText(sender: NeoButton){
        sender.setShadows()
        let viewc = TextController()
        viewc.delegate = self
        self.present(viewc, animated: true, completion: nil)
    }
    
    @objc func buttonText2(sender: NeoButton){
        sender.layer.sublayers?.removeFirst(2)
    }
    
    @objc func buttonVoice(sender: NeoButton){
        sender.setShadows()
        
        let voiceVC = VoiceController()
        voiceVC.delegate = self
        self.present(voiceVC, animated: true, completion: nil)
    }
    
    @objc func buttonVoice2(sender: NeoButton){
        sender.layer.sublayers?.removeFirst(2)
    }
    
    func getIngridients(_ array: [String]) {
        print(40)
        if array.count != 0{
            getRecipes(ingridients: array)
            self.numberOfIngredient = array.count
        }
        else{
            self.label2.text = "It seems that you didn’t enter ingridients!"
        }
    }
    
    func getRecipes(ingridients: [String]){
        print(22)
        var buttonStop = NeoButton()
        super.view.subviews.forEach { $0.removeFromSuperview() }
        label2.frame = CGRect(x: 58, y: 200, width: 259, height: 80)
        label2.textColor = UIColor(red: 0.604, green: 0.604, blue: 0.604, alpha: 1)
        label2.text = "Loading your recipes..."
        
        label2.font = UIFont(name: "Harmattan-Regular", size: 20)
        label2.textAlignment = .center
        label2.numberOfLines = 0
        label2.lineBreakMode = .byWordWrapping
        
        buttonStop.load(title: "stop searching process", frame: CGRect(x: 58, y: 400, width: 259, height: 58))
        buttonStop.addTarget(self, action: #selector(stopProcess(_:)), for: .touchDown)
        super.view.addSubview(label2)
        super.view.addSubview(buttonStop)
        
        AddConstraints(view: label2, top: 200, height: 80, width: 259)
        //optimizing string for request
            
        self.checker = 0
        for i in ingridients
        {
            let url_check = "https://api.edamam.com/search?q=\(i)&app_id=ff10aa7b&app_key=2cc3b582558c8fa5ec04b81d34c537b1"
            AF.request(url_check).responseDecodable(of: Welcome.self){
                response in
                switch response.result{
                    case .success(let value):
                        if value.count != 0{
                            print("YEAH")
                            self.string += i + "%20"
                            print(1)
                            self.checker += 1
                            if self.checker == ingridients.count && self.string != ""
                            {
                                self.getrecipes()
                                
                            }
                            else if self.checker == ingridients.count{
                                self.loadViewWithoutCards()
                                self.label2.text = "There's no result for your search. Enter ingredients correctly!"
                            }
                        }
                        else{
                            print("ERROR")
                            print(1)
                            self.checker += 1
                            if self.checker == ingridients.count && self.string != ""
                            {
                                self.getrecipes()
                                
                            }
                            else if self.checker == ingridients.count{
                                self.loadViewWithoutCards()
                                self.label2.text = "There's no result for your search. Enter ingredients correctly!"
                            }
                        }
                    case .failure(let error):
                        print("ERROR")
                        print(error)
                        print(2)
                        self.checker += 1
                        if self.checker == ingridients.count && self.string != ""
                        {
                            
                            self.getrecipes()
                            
                        }
                        else if self.checker == ingridients.count{
                            self.loadViewWithoutCards()
                            self.label2.text = "There's no result for your search. Enter ingredients correctly!"
                        }
                    }
                }
            }
    }

    func getrecipes(){
        print(33)
        if self.string != "" {
            print("enter")
            let url = "https://api.edamam.com/search?q=\(self.string)&app_id=ff10aa7b&app_key=2cc3b582558c8fa5ec04b81d34c537b1"
                   AF.request(url).responseDecodable(of: Welcome.self){
                       response in
                       guard let recipes = response.value else {return}
                       
                       self.loadViewWithCards(recipes: recipes)
                       }
               }
        else{
           print("failed")
           //self.loadViewWithoutCards()
           //self.label2.text = "There're no recipes for your ingredients. Enter them correctly."
           }
    }
    @objc func stopProcess(_ sender: NeoButton){
        let vc = RootViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
        vc.selectedIndex = 1
    }
    
}

