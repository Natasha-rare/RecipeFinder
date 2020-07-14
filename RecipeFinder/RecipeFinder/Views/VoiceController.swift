import Foundation
import UIKit
import Speech

class VoiceController: UIViewController{
    var label = UILabel()
    var labelHead = UILabel()
    var button = NeoButton()
    let audioEngine = AVAudioEngine()
    var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru_RU"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var task: SFSpeechRecognitionTask!
    var isStart: Bool = false
    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        super.viewDidLoad()
        label.frame = CGRect(x: 3, y: 246, width: 370, height: 100)
        label.textColor = UIColor.lightGray
        label.text = "Your ingridients will be here."
        label.font = UIFont(name: "Roboto", size: 19)
        label.textAlignment = .center
        label.numberOfLines = 100
        super.view.addSubview(label)
        labelHead.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        labelHead.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        labelHead.text = "Just speak"
        labelHead.font = UIFont(name: "Georgia", size: 43)
        labelHead.textAlignment = .center
        super.view.addSubview(labelHead)
        button.load(title: "start", frame: CGRect(x: 58, y: 584, width: 259, height: 58))
        button.addTarget(self, action: #selector(self.buttonStart(sender:)), for: .touchUpInside)
        super.view.addSubview(button)
        requestPermission()
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
            if response != nil{
            guard let response = response else{
                if error != nil {
                    self.alertView(message: error.debugDescription)
                }else{
                    self.alertView(message: "Problem in giving the response")
                }
                return
            }
            let message = response.bestTranscription.formattedString
                self.label.text = message}
            else{
                self.alertView(message: "There must have been some problem")
            }
        })
    }
    func cancelSpeechRecognition(){
        task.finish()
        //task.cancel()
        task = nil
        
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    @objc func buttonStart(sender: Any){
        isStart = !isStart
        if isStart{
            startSpeechRecognition()
            button.setTitle("done", for: .normal)
        }
        else{
            cancelSpeechRecognition()
            button.setTitle("start", for: .normal)
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
        self.button.isEnabled = false
        SFSpeechRecognizer.requestAuthorization({(authState) in
            OperationQueue.main.addOperation {
                if authState == .authorized{
                    print("ACCEPTED")
                    self.button.isEnabled = true
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
