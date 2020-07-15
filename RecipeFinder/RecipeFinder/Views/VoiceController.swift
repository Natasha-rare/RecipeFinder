
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

    var button = NeoButton()
    var label = UILabel()
    var labelHead = UILabel()
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU"))

    var recognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask : SFSpeechRecognitionTask?
    let audioEngine     = AVAudioEngine()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        button.load(title: "start", frame: CGRect(x: 58, y: 584, width: 259, height: 58))
        button.addTarget(self, action: #selector(self.btnStartSpeechToText(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(self.buttonClickedDown(_:)), for: .touchDown)
        super.view.addSubview(button)
        label.frame = CGRect(x: 3, y: 246, width: 370, height: 100)
        label.textColor = UIColor.lightGray
        label.text = "Тут будут ваши ингридиенты."
        label.font = UIFont(name: "Harmattan-Regular", size: 20)
        label.textAlignment = .center
        label.numberOfLines = 100
        super.view.addSubview(label)
        labelHead.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        labelHead.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        labelHead.text = "Just speak"
        labelHead.font = UIFont(name: "Georgia", size: 43)
        labelHead.textAlignment = .center
        super.view.addSubview(labelHead)
        self.setupSpeech()
    }
    @objc func btnStartSpeechToText(_ sender: NeoButton) {
        sender.setShadows()
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.button.isEnabled = false
            self.button.setTitle("start", for: .normal)
        } else {
            self.startRecording()
            self.button.setTitle("done", for: .normal)
        }
    }
    @objc func buttonClickedDown(_ sender: NeoButton) {
        sender.layer.sublayers?.removeFirst(2)
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
        } catch {
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

        self.label.text = "Тут будут ваши ингридиенты."
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
