//
//  AuthController.swift
//  R Sports
//
//  Created by João Pedro Leite on 08/04/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class AuthController: UIViewController {

    @IBOutlet var controllerView: UIView!
    @IBOutlet weak var ballTrailing: NSLayoutConstraint!
    @IBOutlet weak var btnLogin: UIButton!
    
    
    var waitingForPinCode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        phoneText.delegate = self
//        txtSMSCode.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if FirebaseService.getCurrentUser() != nil {
            performSegue(withIdentifier: "AuthToMainSegue", sender: nil)
        } else {
            UIView.animate(withDuration: 0.5) {
                self.ballTrailing.constant = 100
                self.controllerView.alpha = 1.0
            }
        }
    }
    
//    @IBAction func txtPhoneChange(_ sender: Any) {
//        if formatPhone().count == 11 {
//            phoneText.resignFirstResponder()
//        }
//    }
    
    @IBAction func btnLoginClick(_ sender: Any) {
        
//        if !waitingForPinCode {
//            PhoneAuthProvider.provider().verifyPhoneNumber(formatPhone(), uiDelegate: nil) { (verificationID, error) in
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }
//
//                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
//
//                DispatchQueue.main.async {
//                    UIView.animate(withDuration: 0.3, animations: {
//                        self.txtSMSCode.isEnabled = true
//                        self.txtSMSCode.alpha = 1
//                        self.btnLogin.setTitle("Enviar código", for: .normal)
//                        self.waitingForPinCode = true
//                    })
//                }
//            }
//        } else {
//
//            if let verificationCode = txtSMSCode.text {
//                let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
//
//
//                let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
//
//                FirebaseService.loginWith(credential: credential) { (success) in
//                    if success {
//                        self.performSegue(withIdentifier: "AuthToMainSegue", sender: nil)
//                    }
//                }
//
//            }
//        }
    }

//    func formatPhone() -> String {
//        if var phone = phoneText.text {
//            phone = phone.replacingOccurrences(of: " ", with: "")
//            phone = phone.replacingOccurrences(of: "(", with: "")
//            phone = phone.replacingOccurrences(of: ")", with: "")
//            phone = phone.replacingOccurrences(of: "-", with: "")
//            phone = "+55\(phone)"
//            return phone
//        }
//        return ""
//    }

}


