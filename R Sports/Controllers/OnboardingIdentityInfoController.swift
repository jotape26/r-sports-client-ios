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
            
            let userData : [String : Any] = [ProfileConstants.NAME : txtNome.text ?? "",
                                             ProfileConstants.AGE : Int(txtIdade.text ?? "") ?? 0,
                                             ProfileConstants.EMAIL : txtEmail.text ?? ""]
            
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
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        
        UIView.animate(withDuration: 1) {
            textField.backgroundColor = AppConstants.ColorConstants.defaultGreen
            textField.layoutIfNeeded()
        }
    }

}
