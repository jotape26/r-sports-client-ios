//
//  OnboardingPlaystyleController.swift
//  R Sports
//
//  Created by João Leite on 08/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class OnboardingPlaystyleController: UIViewController {
    
    @IBOutlet weak var txtPosition: UITextField!
    @IBOutlet weak var txtCompetitividade: UITextField!
    @IBOutlet weak var segmentJogos: UISegmentedControl!
    
    let pickerPosition = UIPickerView()
    let pickerCompetitivity = UIPickerView()
    
    let options = [["Ataque",
                    "Meio Campo",
                    "Defesa",
                    "Goleiro"],
                   ["Casual",
                    "Médio",
                    "Competitivo"]
                   ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        pickerPosition.delegate = self
        pickerPosition.dataSource = self
        
        pickerCompetitivity.delegate = self
        pickerCompetitivity.dataSource = self
        
        txtPosition.inputView = pickerPosition
        txtCompetitividade.inputView = pickerCompetitivity
    }
    
    func validateFields() -> Bool {
        if txtPosition.text == "" {
            txtPosition.setTextInvalid()
            return false
        }
        
        if txtCompetitividade.text == "" {
            txtCompetitividade.setTextInvalid()
            return false
        }
        
        return true
    }

    @IBAction func btnContinuarClick(_ sender: Any) {
        
        if validateFields() {
            let data : [String : Any] = [ProfileConstants.POSITION : txtPosition.text ?? "",
                                         ProfileConstants.COMPETITIVITY : txtCompetitividade.text ?? "",
                                         ProfileConstants.SEARCHING_GAMES : segmentJogos.selectedSegmentIndex == 1 ? true : false]
            
            FirebaseService.setUserData(data: data)
            performSegue(withIdentifier: "PlaystyleToFinishSegue", sender: nil)
        }
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        
        UIView.animate(withDuration: 1) {
            textField.backgroundColor = AppConstants.ColorConstants.defaultGreen
            textField.layoutIfNeeded()
        }
    }
    
}

extension OnboardingPlaystyleController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerPosition {
            return options[0].count
        } else {
            return options[1].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerPosition {
            return options[0][row]
        } else {
            return options[1][row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerPosition {
            txtPosition.text = options[0][row]
            txtPosition.resignFirstResponder()
        } else {
            txtCompetitividade.text = options[1][row]
            txtCompetitividade.resignFirstResponder()
        }
    }
}
