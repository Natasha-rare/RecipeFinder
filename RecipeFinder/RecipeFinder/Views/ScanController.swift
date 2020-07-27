//
//  ScanController.swift
//  RecipeFinder
//
//  Created by Daniel Khromov on 7/13/20.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import Foundation
import UIKit
import Vision

class ScanController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    weak var delegate: RecipeArrayDelegate?

    var resultLabel = UILabel()
    let vc = UIImagePickerController()
    var buttonCamera = UIButton()
    var buttonLibrary = UIButton()
    var buttonDone = NeoButton()
    var productsList: [String] = []
    var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
        resultLabel.text = NSLocalizedString("Choose image", comment: "")
        resultLabel.frame = CGRect(x: 135, y: 50, width: 400, height: 20)
        resultLabel.textColor = .black
        resultLabel.font = UIFont(name: "Harmattan-Regular", size: 20)
        resultLabel.textAlignment = .center

        buttonCamera.frame = CGRect(x: 113, y: 420, width: 150, height: 58)
        buttonCamera.setTitle(NSLocalizedString("take a photo", comment: ""), for: .normal)
        buttonCamera.setTitleColor(UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1), for: .normal)
        buttonCamera.backgroundColor = view.backgroundColor
        buttonCamera.layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor
        buttonCamera.layer.cornerRadius = 30
        buttonCamera.layer.masksToBounds = true
        buttonCamera.layer.borderWidth = 1
        buttonCamera.addTarget(self, action: #selector(self.buttonCameraPressed), for: .touchUpInside)


        buttonLibrary.frame = CGRect(x: 113, y: 500, width: 150, height: 58)
        buttonLibrary.setTitle(NSLocalizedString("from library", comment: ""), for: .normal)
        buttonLibrary.setTitleColor(UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1), for: .normal)
        buttonLibrary.backgroundColor = view.backgroundColor
        buttonLibrary.layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor
        buttonLibrary.layer.cornerRadius = 30
        buttonLibrary.layer.masksToBounds = true
        buttonLibrary.layer.borderWidth = 1
        buttonLibrary.addTarget(self, action: #selector(self.buttonLibraryPressed), for: .touchUpInside)

        buttonDone.load(title: NSLocalizedString("done", comment: ""), frame: CGRect(x: 58, y: 600, width: 257, height: 58))
        buttonDone.addTarget(self, action: #selector(self.buttonDonePressed(sender:)), for: .touchDown)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 680)
        
        scrollView.addSubview(resultLabel)
        AddConstraints(view: resultLabel, top: 50, height: 20, width: 400)
        
        scrollView.addSubview(buttonLibrary)
        AddConstraints(view: buttonLibrary, top: 500, height: 58, width: 150)
        
        scrollView.addSubview(buttonCamera)
        AddConstraints(view: buttonCamera, top: 420, height: 58, width: 150)
        
        scrollView.addSubview(buttonDone)
        AddConstraints(view: buttonDone, top: 600, height: 58, width: 257)
        
        super.view.addSubview(scrollView)
        ScrollViewConstraints(view: scrollView)
    }
    
    @objc func buttonCameraPressed(){
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc func buttonLibraryPressed(){
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc func buttonDonePressed(sender: NeoButton){
        if (self.resultLabel.text?.contains(" "))!{
            productsList = self.resultLabel.text!.components(separatedBy: " ")
        }
        else{
            productsList.append(self.resultLabel.text!)
        }
        
        print(productsList)
        
        sender.setShadows()
        sender.layer.sublayers?.removeFirst(2)
        
        self.delegate?.getIngridients(productsList)
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }

        classifyImage(image)
    }

    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            // 2
            var model = try VNCoreMLModel(for: SqueezeNet().model)

            if #available(iOS 12.0, *) {
                model = try VNCoreMLModel(for: Fridge_copy().model)
            }

            // 3
            let request = VNCoreMLRequest(model: model) { request, _ in
                if let classifications =
                  request.results as? [VNClassificationObservation] {
                    self.processClassifications(for: request)
                }
            }

            // 4
            request.imageCropAndScaleOption = .centerCrop
            return request
        }
        catch {
            // 5
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()

    func classifyImage(_ image: UIImage) {
        // 1
        guard let orientation = CGImagePropertyOrientation(
            rawValue: UInt32(image.imageOrientation.rawValue)) else {
        return
        }

        guard let ciImage = CIImage(image: image) else {
            fatalError("Unable to create \(CIImage.self) from \(image).")
        }

        // 2
        DispatchQueue.global(qos: .userInitiated).async {
            let handler =
              VNImageRequestHandler(ciImage: ciImage, orientation: orientation)

            do {
                try handler.perform([self.classificationRequest])
            }
            catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }


    func processClassifications(for request: VNRequest) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.resultLabel.text = NSLocalizedString("Unable to classify image.", comment: "")
                return
            }

            let classifications = results as! [VNClassificationObservation]

            if classifications.isEmpty {
                self.resultLabel.text = NSLocalizedString("Nothing recognized.", comment: "")
            }
            else {
                let topClassifications = classifications.prefix(1)
                let descriptions = topClassifications.map { classification in
                    return String(classification.identifier)
                }
                if self.resultLabel.text == NSLocalizedString("Choose image", comment: ""){
                    self.resultLabel.text = descriptions.joined()
                }
                else {
                    self.resultLabel.text = self.resultLabel.text! + " " +  descriptions.joined()
                }
            }
        }
    }
}


