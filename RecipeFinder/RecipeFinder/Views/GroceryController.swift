import Foundation
import UIKit
import Speech

class GroceryController: UIViewController{
    var label = UILabel()
    var button = UIButton()
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var task: SFSpeechRecognitionTask!
    var isStart: Bool = false
    var labelHead = UILabel()
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        label.frame = CGRect(x: 3, y: 85, width: 370, height: 53)
        label.textColor = UIColor.black
        label.text = ""
        label.font = UIFont(name: "Georgia", size: 10)
        label.textAlignment = .center
        label.numberOfLines = 12
        super.view.addSubview(label)
        button.setTitle("Start", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemPink
        button.frame = CGRect(x: 47, y: 520, width: 274, height: 77)
        button.addTarget(self, action: #selector(self.buttonStart(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 15.0
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.systemPink.cgColor
        
        labelHead.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        labelHead.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        labelHead.text = "Grocery"
        labelHead.font = UIFont(name: "Georgia", size: 43)
        labelHead.textAlignment = .center
        super.view.addSubview(button)
        super.view.addSubview(labelHead)
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
            guard let response = response else{
                if error != nil {
                    self.alertView(message: error.debugDescription)
                }else{
                    self.alertView(message: "Problem in giving the response")
                }
                return
            }
            let message = response.bestTranscription.formattedString
            self.label.text = message
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
            button.setTitle("Srop", for: .normal)
        }
        else{
            cancelSpeechRecognition()
            button.setTitle("Start", for: .normal)
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
