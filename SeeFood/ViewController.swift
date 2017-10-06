//
//  ViewController.swift
//  SeeFood
//
//  Created by Jonas Elholm on 03/10/2017.
//  Copyright © 2017 ButlerStar. All rights reserved.
//

import UIKit
import CoreML
import Vision



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    
    @IBOutlet weak var UIImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            UIImageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                
                fatalError("Could not convert to CIImage")
                
                }
            
            detect(image: ciimage)
            
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            
            fatalError("Loading COREML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
                
            }
            if let firstResult = results.first {
                
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog!"
                }   else {
                    
                    self.navigationItem.title = "Not Hotdog!"
                }
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            
            try handler.perform([request])
        }
        catch {
            print(error)
        }
        
    }
 
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    

}
}
