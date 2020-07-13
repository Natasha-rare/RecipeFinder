
import UIKit


class GroceryController: UIViewController{
    var label = UILabel()

    var buttonEnter = NeoButton()
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        
        label.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Grocery"
        label.font = UIFont(name: "Georgia", size: 43)
        label.textAlignment = .center
        
        buttonEnter.load(title: "clear all", frame: CGRect(x: 58, y: 589, width: 259, height: 58))
        buttonEnter.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        super.view.addSubview(label)
//
//    var button = UIButton()
//    let audioEngine = AVAudioEngine()
//    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
//    let request = SFSpeechAudioBufferRecognitionRequest()
//    var task: SFSpeechRecognitionTask!
//    var isStart: Bool = false
//    var labelHead = UILabel()
//    override func viewDidLoad() {
//        view.backgroundColor = .white
//        super.viewDidLoad()
//        label.frame = CGRect(x: 3, y: 85, width: 370, height: 53)
//        label.textColor = UIColor.black
//        label.text = ""
//        label.font = UIFont(name: "Georgia", size: 10)
//        label.textAlignment = .center
//        label.numberOfLines = 12
//        super.view.addSubview(label)
//        button.setTitle("Start", for: .normal)
//        button.setTitleColor(UIColor.white, for: .normal)
//        button.backgroundColor = .systemPink
//        button.frame = CGRect(x: 47, y: 520, width: 274, height: 77)
//        button.addTarget(self, action: #selector(self.buttonStart(sender:)), for: .touchUpInside)
//        button.layer.cornerRadius = 15.0
//        button.layer.borderWidth = 2.0
//        button.layer.borderColor = UIColor.systemPink.cgColor
//
//        labelHead.frame = CGRect(x: 0, y: 28, width: 375, height: 79)
//        labelHead.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//        labelHead.text = "Grocery"
//        labelHead.font = UIFont(name: "Georgia", size: 43)
//        labelHead.textAlignment = .center
//        super.view.addSubview(button)
//        super.view.addSubview(labelHead)
//        requestPermission()
//    }
//    func startSpeechRecognition(){
//        let node = audioEngine.inputNode
//        let recordingFormat = node.outputFormat(forBus: 0)
//        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat)  {(buffer, _) in
//            self.request.append(buffer)
//        }
//        audioEngine.prepare()
//        do{
//            try audioEngine.start()
//        } catch let error{
//            alertView(message: "Error comes here = \(error.localizedDescription)")
//        }
//        guard let myRecognization = SFSpeechRecognizer() else{
//            self.alertView(message: "Recognization is not allowed")
//            return
//        }
//        if !myRecognization.isAvailable{
//            self.alertView(message: "Recognization is free right now. Please try again after some time.")
//        }
//        task = speechRecognizer?.recognitionTask(with: request, resultHandler: {(response, error) in
//            guard let response = response else{
//                if error != nil {
//                    self.alertView(message: error.debugDescription)
//                }else{
//                    self.alertView(message: "Problem in giving the response")
//                }
//                return
//            }
//            let message = response.bestTranscription.formattedString
//            self.label.text = message
//        })
        
    }

    @objc func buttonClicked(sender : UIButton) {
        
    }
    
}
