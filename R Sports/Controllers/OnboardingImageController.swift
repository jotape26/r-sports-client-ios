//
//  OnboardingImageController.swift
//  R Sports
//
//  Created by João Leite on 08/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import Photos

class OnboardingImageController: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imgProfile.setRounded()
    }
    
    @IBAction func btnAdicionarClick(_ sender: Any) {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    self.presentPickerView()
                }
            })
        } else if photos == .authorized {
            self.presentPickerView()
        }
    }
    
    func presentPickerView(){
        let viewController = UIImagePickerController()
        viewController.delegate = self
        viewController.sourceType = .camera
        viewController.allowsEditing = false
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnContinuarClick(_ sender: Any) {
        performSegue(withIdentifier: "ImageToPlaystyleSegue", sender: nil)
    }
}

extension OnboardingImageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.imgProfile.image = image
            FilesManager.saveImageToDisk(image: image)
            FirebaseService.saveUserImage(userImage: image, success: {}) {}
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}
