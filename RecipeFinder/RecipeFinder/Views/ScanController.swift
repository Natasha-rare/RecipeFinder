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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
        
        resultLabel.text = "Choose image"
        resultLabel.frame = CGRect(x: 20, y: 50, width: 400, height: 20)
        resultLabel.textColor = .black
        resultLabel.font = UIFont.systemFont(ofSize: 19)
        
        super.view.addSubview(resultLabel)
        
        
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
        let model = try VNCoreMLModel(for: SqueezeNet().model)
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
      } catch {
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
        } catch {
          print("Failed to perform classification.\n\(error.localizedDescription)")
        }
      }
    }
    
    
    func processClassifications(for request: VNRequest) {
    DispatchQueue.main.async {
       guard let results = request.results
       else {
         self.resultLabel.text = "Unable to classify image."
         return
       }
       let classifications = results as! [VNClassificationObservation]
       if classifications.isEmpty {
         self.resultLabel.text = "Nothing recognized."
       } else {
         let topClassifications = classifications.prefix(1)
         let descriptions = topClassifications.map { classification in
           return String(classification.identifier)
       }
        self.resultLabel.text = descriptions.joined()
      }
    }
}
}
