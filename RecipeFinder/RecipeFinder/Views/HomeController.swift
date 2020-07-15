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
    var cardViewEnabled: Bool = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        loadViewWithoutCards()
        requestPermission()
    }
    
    @objc func buttonRegistr(sender : UIButton) {
        let viewc = ScanController()
        self.present(viewc, animated: true, completion: nil)
    }
    
    @objc func buttonText(sender: NeoButton){
        let viewc = TextController()
        viewc.delegate = self
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

