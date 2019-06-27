//
//  OnboardingCreateAccountController.swift
//  R Sports
//
//  Created by João Leite on 08/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import FirebaseAuth

class OnboardingCreateAccountController: UIViewController {

    @IBOutlet weak var txtCelNumber: SwiftMaskTextfield!
    @IBOutlet weak var txtPin: KAPinField!
    @IBOutlet weak var btnConfirmar: UIButton!
    @IBOutlet weak var labelPinHeight: NSLayoutConstraint!
    @IBOutlet weak var txtPinHeight: NSLayoutConstraint!
    @IBOutlet weak var btnVoltar: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnConfirmar.layer.cornerRadius = 5.0
        btnVoltar.layer.cornerRadius = 5.0
        txtCelNumber.delegate = self
        txtPin.properties.delegate = self
        txtPin.properties.numberOfCharacters = 6
        txtPin.reloadAppearance()
    }

    @IBAction func btnConfirmarClick(_ sender: Any) {
            self.view.startLoading()
            PhoneService.sendVerificationCode(phoneNumber: txtCelNumber.formatToPhone(), success: {
                
                self.view.layoutIfNeeded()
                
                DispatchQueue.main.async {
                    self.view.stopLoading()
                    self.labelPinHeight.constant = 20
                    self.txtPinHeight.constant = 50
                    self.btnConfirmar.setTitle("Confirmar PIN", for: .normal)
                    self.view.layoutIfNeeded()
                }
                
                _ = self.txtPin.becomeFirstResponder()
            }) { error in
                AlertBroker.showAlert(title: "Error", description: error.localizedDescription, view: self)
                self.view.stopLoading()
            }
    }
    @IBAction func btnVoltarClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension OnboardingImageController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? false {
            textField.text = "55"
        }
    }
}

extension OnboardingCreateAccountController: KAPinFieldDelegate {
    func pinField(_ field: KAPinField, didFinishWith code: String) {
        self.view.startLoading()
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        FirebaseService.loginWith(credential: credential, register: true) { (success) in
            if success {
                self.view.stopLoading()
                self.performSegue(withIdentifier: "CreateProfileSegue", sender: nil)
            }
        }
    }
}
