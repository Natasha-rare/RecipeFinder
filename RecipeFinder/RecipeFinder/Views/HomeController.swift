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

class HomeController: UIViewController{
    let label = UILabel()
    let label2 = UILabel()
    let buttonText = NeoButton()
    let buttonVoice = NeoButton()
    let buttonScan = NeoButton()
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var task: SFSpeechRecognitionTask!
    var isStart: Bool = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        getRecipes()
        
        
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
        
        buttonText.load(title: "text", frame: CGRect(x: 113, y: 333, width: 150, height: 58))
        buttonVoice.load(title: "voice", frame: CGRect(x: 113, y: 433, width: 150, height: 58))
        buttonScan.load(title: "camera", frame: CGRect(x: 113, y: 533, width: 150, height: 58))
        
        buttonScan.addTarget(self, action: #selector(self.buttonRegistr(sender:)), for: .touchUpInside)
        buttonVoice.addTarget(self, action: #selector(self.buttonVoice(sender:)), for: .touchUpInside)
        buttonText.addTarget(self, action: #selector(self.buttonText(sender:)), for: .touchUpInside)
        
        let camera = UIImage(named: "camera.png")
        let cameraView = UIImageView(image: camera)
        cameraView.frame = CGRect(x: 62, y: 547, width: 30, height: 30)
        
        let text = UIImage(named: "Text.png")
        let textView = UIImageView(image: text)
        textView.frame = CGRect(x: 62, y: 347, width: 30, height: 30)
        
        let voice = UIImage(named: "voice.png")
        let voiceView = UIImageView(image: voice)
        voiceView.frame = CGRect(x: 62, y: 447, width: 30, height: 30)
        
        super.view.addSubview(label)
        super.view.addSubview(label2)
        super.view.addSubview(buttonText)
        super.view.addSubview(buttonVoice)
        super.view.addSubview(buttonScan)
        super.view.addSubview(cameraView)
        super.view.addSubview(textView)
        super.view.addSubview(voiceView)
        requestPermission()
    }
    
    @objc func buttonRegistr(sender : UIButton) {
        let viewc = ScanController()
        self.present(viewc, animated: true, completion: nil)
    }
    
    @objc func buttonText(sender: NeoButton){
        let viewc = TextController()
        self.present(viewc, animated: true, completion: nil)
    }
    
    @objc func buttonVoice(sender: UIButton){
        let voiceVC = VoiceController()
        self.present(voiceVC, animated: true, completion: nil)
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
