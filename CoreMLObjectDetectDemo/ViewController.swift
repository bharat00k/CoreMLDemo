//
//  ViewController.swift
//  CoreMLObjectDetectDemo
//
//  Created by Bharat Khatke on 08/05/20.
//  Copyright © 2020 Bharat Khatke. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
    }
    
    @IBAction func cameraBtnPressed(_ sender: UIBarButtonItem) {
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func photoLibBtnPressed(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func detect(image: CIImage)  {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else{
                fatalError("There is problem for VNClassification observation ")
            }
            
            if let firstResult = result.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog!"
                }else {
                    self.navigationItem.title = "Not Hot Dog"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    
    //MARK:- Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let captureImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) {
          self.imageView.image = captureImage
            
            guard let ciImage = CIImage(image: captureImage) else {
                fatalError("There is problem in converting image into CIImage")
            }
            detect(image: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

