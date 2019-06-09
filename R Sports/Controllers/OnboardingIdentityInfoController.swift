//
//  OnboardingIdentityInfoController.swift
//  R Sports
//
//  Created by João Leite on 08/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class OnboardingIdentityInfoController: UIViewController {

    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtIdade: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtNome.delegate = self
        txtIdade.delegate = self
        txtEmail.delegate = self
    }
    
    @IBAction func btnContinuarClick(_ sender: Any) {
        
        if validateFields() {
            
            let userData : [String : Any] = ["userName" : txtNome.text ?? "",
                                             "userAge" : Int(txtIdade.text ?? "") ?? 0,
                                             "userEmail" : txtEmail.text ?? ""]
            
            FirebaseService.setUserData(data: userData)
            performSegue(withIdentifier: "IdentityToPhotoSegue", sender: nil)
        }
    }
    
    func validateFields() -> Bool {
        if txtNome.text ?? "" == "" {
            txtNome.setTextInvalid()
            return false
        }
        
        if Int(txtIdade.text ?? "") == nil {
            txtIdade.setTextInvalid()
            return false
        }
        
        if txtEmail.text ?? "" == "" {
            txtEmail.setTextInvalid()
            return false
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 1) {
            textField.backgroundColor = #colorLiteral(red: 0.06028468404, green: 0.3637206691, blue: 0.2629516992, alpha: 1)
            textField.layoutIfNeeded()
        }
    }

}
