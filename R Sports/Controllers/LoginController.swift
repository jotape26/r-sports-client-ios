//
//  LoginController.swift
//  R Sports
//
//  Created by João Leite on 08/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation
import NKVPhonePicker

class LoginController: UIViewController {
    
    @IBOutlet weak var txtCelNumber: NKVPhonePickerTextField!
    @IBOutlet weak var txtPin: KAPinField!
    @IBOutlet weak var lblPin: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnVoltar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        txtPin.properties.delegate = self
        txtPin.properties.numberOfCharacters = 6
        txtPin.reloadAppearance()
        txtCelNumber.delegate = self
        txtCelNumber.phonePickerDelegate = self
        btnConfirm.layer.cornerRadius = 5.0
        btnVoltar.layer.cornerRadius = 5.0
        configurePhoneTextField(txtCelNumber)
    }
    
    @IBAction func btnEntrarClick(_ sender: Any) {
        self.view.startLoading()
        PhoneService.sendVerificationCode(phoneNumber: txtCelNumber.formatToPhone(), success: {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.stopLoading()
                    self.txtPin.isEnabled = true
                    self.txtPin.alpha = 1
                    self.lblPin.alpha = 1
                    _ = self.txtPin.becomeFirstResponder()
                })
            }
        }) { error in
            AlertsHelper.showSystemAlert(title: "Error", description: error.localizedDescription, view: self)
            self.view.stopLoading()
        }
        
    }
    
    
    @IBAction func btnVoltarClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LoginController: KAPinFieldDelegate {
    func pinField(_ field: KAPinField, didFinishWith code: String) {
        self.view.startLoading()
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        FirebaseService.loginWith(credential: credential) { (success) in
            if success {
                self.view.stopLoading()
                self.performSegue(withIdentifier: "LoginToMainSegue", sender: nil)
            }
        }
    }
}
