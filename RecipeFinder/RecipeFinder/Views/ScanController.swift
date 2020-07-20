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
    var resultLabel = UILabel()
    let vc = UIImagePickerController()
    var buttonCamera = UIButton()
    var buttonLibrary = UIButton()
    var buttonDone = NeoButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
//
        
        
        
        resultLabel.text = "Choose image"
        resultLabel.frame = CGRect(x: 100, y: 50, width: 400, height: 20)
        resultLabel.textColor = .black
        resultLabel.font = UIFont(name: "Harmattan-Regular", size: 20)
        buttonCamera.frame = CGRect(x: 113, y: 420, width: 150, height: 58)
        buttonCamera.setTitle("take a photo", for: .normal)
        buttonCamera.setTitleColor(UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1), for: .normal)
        buttonCamera.backgroundColor = view.backgroundColor
        buttonCamera.layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor
        buttonCamera.layer.cornerRadius = 30
        buttonCamera.layer.masksToBounds = true
        buttonCamera.layer.borderWidth = 1
        buttonCamera.addTarget(self, action: #selector(self.buttonCameraPressed), for: .touchUpInside)
        
        buttonLibrary.frame = CGRect(x: 113, y: 500, width: 150, height: 58)
        buttonLibrary.setTitle("from library", for: .normal)
        buttonLibrary.setTitleColor(UIColor(red: 0.647, green: 0.212, blue: 0.027, alpha: 1), for: .normal)
        buttonLibrary.backgroundColor = view.backgroundColor
        buttonLibrary.layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor
        buttonLibrary.layer.cornerRadius = 30
        buttonLibrary.layer.masksToBounds = true
        buttonLibrary.layer.borderWidth = 1
        buttonLibrary.addTarget(self, action: #selector(self.buttonLibraryPressed), for: .touchUpInside)
        
        buttonDone.load(title: "done", frame: CGRect(x: 58, y: 600, width: 257, height: 58))
        buttonDone.addTarget(self, action: #selector(self.buttonDonePressed), for: .touchDown)
        super.view.addSubview(resultLabel)
        super.view.addSubview(buttonLibrary)
        super.view.addSubview(buttonCamera)
        AddConstraints(view: resultLabel, top: 100, height: 20, width: 400)
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
    @objc func buttonDonePressed(){
        
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
                self.resultLabel.text = "Unable to classify image."
                return
            }
            
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                self.resultLabel.text = "Nothing recognized."
            }
            else {
                let topClassifications = classifications.prefix(1)
                let descriptions = topClassifications.map { classification in
                    return String(classification.identifier)
                }
                
                self.resultLabel.text = descriptions.joined()
            }
        }
    }
}
