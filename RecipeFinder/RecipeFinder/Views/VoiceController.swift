
//
//  ExController.swift
//  RecipeFinder
//
//  Created by I on 15.07.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import UIKit
import Speech
import AVKit

class VoiceController: UIViewController {

    weak var delegate: RecipeArrayDelegate?
    
    var button = UIButton()
    var buttonSet = NeoButton()
    var label = UILabel()
    var labelHead = UILabel()
    let speechRecognizer = SFSpeechRecognizer()
    var doneButton = NeoButton()
    var productsList: [String] = []
    var scrollView = UIScrollView()
    
    var recognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask : SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    var ingredients:[String] = []
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        
        button.frame = CGRect(x: 113, y: 500, width: 150, height: 58)
        button.setTitle(NSLocalizedString("start", comment: ""), for: .normal)
        button.setTitleColor(UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1), for: .normal)
        button.backgroundColor = view.backgroundColor
        button.layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.btnStartSpeechToText(_:)), for: .touchUpInside)
        
        doneButton.load(title: NSLocalizedString("done", comment: ""), frame: CGRect(x: 113, y: 584, width: 150, height: 58))
        doneButton.addTarget(self, action: #selector(self.buttonDoneClicked(_:)), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(self.buttonClickedDown(_:)), for: .touchDown)
        
        label.frame = CGRect(x: 58, y: 200, width: 259, height: 80)
        label.textColor = UIColor(red: 0.604, green: 0.604, blue: 0.604, alpha: 1)
        label.text = NSLocalizedString("It seems that you didn’t enter ingridients!", comment: "")
        label.font = UIFont(name: "Harmattan-Regular", size: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        labelHead.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        labelHead.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        labelHead.text = NSLocalizedString("Just speak", comment: "")
        labelHead.font = UIFont(name: "Georgia", size: 43)
        labelHead.textAlignment = .center
        
        let imageSound = UIImageView(image: UIImage(named: "sound.png"))
        imageSound.frame = CGRect(x: 67, y: 377, width: 257, height: 67)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 650)
        
        scrollView.addSubview(button)
        AddConstraints(view: button, top: 500, height: 58, width: 150)
        
        scrollView.addSubview(doneButton)
        AddConstraints(view: doneButton, top: 584, height: 58, width: 150)
        
        scrollView.addSubview(label)
        AddConstraints(view: label, top: 200, height: 80, width: 259)
        
        scrollView.addSubview(labelHead)
        AddConstraints(view: labelHead, top: 38, height: 79, width: 375)
        
        scrollView.addSubview(imageSound)
        AddConstraints(view: imageSound, top: 377, height: 67, width: 257)
        
        super.view.addSubview(scrollView)
        ScrollViewConstraints(view: scrollView)
        
        self.setupSpeech()
    }
    
    @objc func btnStartSpeechToText(_ sender: UIButton) {
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.button.isEnabled = false
            self.button.setTitle(NSLocalizedString("start", comment: ""), for: .normal)
        }
        else {
            self.startRecording()
            self.button.setTitle(NSLocalizedString("stop", comment: ""), for: .normal)
        }
    }
    
    @objc func buttonClickedDown(_ sender: NeoButton) {
        sender.layer.sublayers?.removeFirst(2)
    }
    
    @objc func buttonDoneClicked(_ sender: UIButton){
        if label.text != NSLocalizedString("It seems that you didn’t enter ingridients!", comment: "")
        {
        productsList = label.text!.components(separatedBy: " ")
        self.delegate?.getIngridients(productsList)
        }
        self.dismiss(animated: true, completion: nil)
    }

    func setupSpeech() {
        self.button.isEnabled = false
        self.speechRecognizer?.delegate = self

        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false

            switch authStatus {
                case .authorized:
                    isButtonEnabled = true

                case .denied:
                    isButtonEnabled = false
                    print("User denied access to speech recognition")

                case .restricted:
                    isButtonEnabled = false
                    print("Speech recognition restricted on this device")

                case .notDetermined:
                    isButtonEnabled = false
                    print("Speech recognition not yet authorized")
                @unknown default:
                    isButtonEnabled = false
                    print("unknown default")
            }

            OperationQueue.main.addOperation() {
                self.button.isEnabled = isButtonEnabled
            }
        }
    }

    func startRecording() {
        
        // Clear all previous session data and cancel task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        // Create instance of audio session to record voice
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        }
        catch {
            print("audioSession properties weren't set because of an error.")
        }

        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }

        recognitionRequest.shouldReportPartialResults = true

        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false

            if result != nil {
                self.label.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }

            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                self.button.isEnabled = true
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        self.audioEngine.prepare()

        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
}

extension VoiceController: SFSpeechRecognizerDelegate {

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.button.isEnabled = true
        } else {
            self.button.isEnabled = false
        }
    }
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
