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
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
//        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
        loadViewWithoutCards()
        requestPermission()
    }

    
    
    //touch up/down
    @objc func buttonRegistr(sender : NeoButton) {
        sender.setShadows()
        
        let viewc = ScanController()
        self.present(viewc, animated: true, completion: nil)
    }
    @objc func buttonRegistr2(sender : NeoButton) {
        sender.layer.sublayers?.removeFirst(2)
    }
    
    @objc func imageTapped(sender: CardImage){
        print(sender.urlIm)
        let vc = WebViewController()
        vc.url = sender.urlIm
        self.present(vc, animated: true, completion: nil)
    }
    
    //touch up/down
    @objc func buttonText(sender: NeoButton){
        sender.setShadows()
        let viewc = TextController()
        viewc.delegate = self
        self.present(viewc, animated: true, completion: nil)
    }
    @objc func buttonText2(sender: NeoButton){
        sender.layer.sublayers?.removeFirst(2)
    }
    
    //touch up/down
    @objc func buttonVoice(sender: NeoButton){
        sender.setShadows()
        
        let voiceVC = VoiceController()
        self.present(voiceVC, animated: true, completion: nil)
    }
    @objc func buttonVoice2(sender: NeoButton){
        sender.layer.sublayers?.removeFirst(2)
    }
    
    func getIngridients(_ array: [String]) {
        if array.count != 0{
            getRecipes(ingridients: array)
            self.numberOfIngredient = array.count
        }
        else{
            self.label2.text = "It seems that you didn’t enter ingridients!"
        }
    }
    
    func getRecipes(ingridients: [String]){
        super.view.subviews.forEach { $0.removeFromSuperview() }
        label2.frame = CGRect(x: 58, y: 200, width: 259, height: 80)
        label2.textColor = UIColor(red: 0.604, green: 0.604, blue: 0.604, alpha: 1)
        label2.text = "Loading your recipes..."
        label2.font = UIFont(name: "Harmattan-Regular", size: 20)
        label2.textAlignment = .center
        label2.numberOfLines = 0
        label2.lineBreakMode = .byWordWrapping
        super.view.addSubview(label2)
        
        //optimizing string for request
        var string: String = ""
        for i in ingridients{
            string += i + "%20"
        }
        let url = "https://api.edamam.com/search?q=\(string)&app_id=ff10aa7b&app_key=2cc3b582558c8fa5ec04b81d34c537b1"
        AF.request(url).responseDecodable(of: Welcome.self){
            response in
            guard let recipes = response.value else {return}
            
            self.loadViewWithCards(recipes: recipes)
        }
    }

    func startSpeechRecognition(){
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat)  {(buffer, _) in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do{
            try audioEngine.start()
        } catch let error{
            alertView(message: "Error comes here = \(error.localizedDescription)")
        }
        guard let myRecognization = SFSpeechRecognizer() else{
            self.alertView(message: "Recognization is not allowed")
            return
        }
        if !myRecognization.isAvailable{
            self.alertView(message: "Recognization is free right now. Please try again after some time.")
        }
        task = speechRecognizer?.recognitionTask(with: request, resultHandler: {(response, error) in
            guard let response = response else{
                if error != nil {
                    self.alertView(message: error.debugDescription)
                }else{
                    self.alertView(message: "Problem in giving the response")
                }
                return
            }
            let message = response.bestTranscription.formattedString
            self.label2.text = message
        })
    }
    func cancelSpeechRecognition(){
        task.finish()
        task.cancel()
        task = nil
        
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    @objc func buttonStart(sender: Any){
        isStart = !isStart
        if isStart{
            startSpeechRecognition()
            buttonVoice.setTitle("Stop", for: .normal)
        }
        else{
            cancelSpeechRecognition()
            buttonVoice.setTitle("Start", for: .normal)
        }
    }
    func alertView(message: String){
        let controller = UIAlertController.init(title: "Error occured!", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_) in
            controller.dismiss(animated: true, completion: nil)
        }))
        self.present(controller, animated: true, completion: nil)
    }
    func requestPermission(){
        self.buttonVoice.isEnabled = false
        SFSpeechRecognizer.requestAuthorization({(authState) in
            OperationQueue.main.addOperation {
                if authState == .authorized{
                    print("ACCEPTED")
                    self.buttonVoice.isEnabled = true
                }else if authState == .denied{
                    print("DENIED")
                    self.alertView(message: "User denied the permition")
                }else if authState == .notDetermined{
                    print("NO SUCH FUNCTION")
                    self.alertView(message: "User has no such function")
                }else if authState == .restricted{
                    print("RESTRICTED")
                    self.alertView(message: "It has been restricted")
                }
            }
        })
    }
    
}

