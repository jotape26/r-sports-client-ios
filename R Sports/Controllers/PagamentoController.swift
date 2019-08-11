//
//  PagamentoController.swift
//  R Sports
//
//  Created by João Pedro Leite on 07/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class PagamentoController: UIViewController {
    
    var currentFrame : CGRect?
    var activeField: UITextField?
    var reserva : ReservaDTO!
    
    let cardValidator = CreditCardValidator()
    @IBOutlet weak var cartaoView: UIView!
    @IBOutlet weak var txtNumeroCartao: SwiftMaskTextfield!
    @IBOutlet weak var txtMesCartao: UITextField!
    @IBOutlet weak var txtCVVCartao: UITextField!
    @IBOutlet weak var txtNomeTitular: UITextField!
    @IBOutlet weak var txtCPF: UITextField!
    
    @IBOutlet weak var btnConfirmar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cartaoView.layer.cornerRadius = 5.0
        btnConfirmar.layer.cornerRadius = 5.0
        
        txtNumeroCartao.setBottomBorder(withColor: .lightGray)
        txtNumeroCartao.delegate = self
        txtMesCartao.setBottomBorder(withColor: .lightGray)
        txtMesCartao.delegate = self
        txtCVVCartao.setBottomBorder(withColor: .lightGray)
        txtCVVCartao.delegate = self
        
        txtNomeTitular.delegate = self
        txtCPF.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"),
                                               object: txtNumeroCartao)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.currentFrame = self.view.bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func textDidChange(){
        if txtNumeroCartao.text?.count == 19 {
            validateCard(number: txtNumeroCartao.text?.replacingOccurrences(of: " ", with: "") ?? "")
        }
    }
    
    @IBAction func confirmarClick(_ sender: Any) {
        performSegue(withIdentifier: "PagamentoToCompleteSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ConfirmacaoController {
            vc.reserva = reserva
        }
    }
    
}

extension PagamentoController {
    
    func validateCard(number: String){
        if cardValidator.validate(string: number) {
            print(cardValidator.type(from: number)?.name)
        }
    }
    
//    // MARK: - KEYBOARD OBSERVER
//    @objc func keyboardWillShow(notification: NSNotification){
//        //Need to calculate keyboard exact size due to Apple suggestions
//        self.scrollView.isScrollEnabled = true
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
//
//        self.scrollView.contentInset = contentInsets
//        self.scrollView.scrollIndicatorInsets = contentInsets
//
//        var aRect : CGRect = self.view.frame
//        aRect.size.height -= keyboardSize!.height
//        if let activeField = self.activeField {
//            if (!aRect.contains(activeField.frame.origin)){
//                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification){
//        //Once keyboard disappears, restore original positions
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
//        self.scrollView.contentInset = contentInsets
//        self.scrollView.scrollIndicatorInsets = contentInsets
//        self.view.endEditing(true)
//        self.scrollView.isScrollEnabled = false
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField){
//        activeField = textField
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField){
//        activeField = nil
//    }
}
