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
    var reserva : CriacaoReservaDTO!
    var reservaLista : ReservaListaDTO!
    
    let cardValidator = CreditCardValidator()
    @IBOutlet weak var cartaoView: UIView!
    @IBOutlet weak var txtNumeroCartao: SwiftMaskTextfield!
    @IBOutlet weak var txtMesCartao: SwiftMaskTextfield!
    @IBOutlet weak var txtCVVCartao: SwiftMaskTextfield!
    @IBOutlet weak var txtNomeTitular: UITextField!
    @IBOutlet weak var txtCPF: SwiftMaskTextfield!
    
    
    @IBOutlet weak var lbNome: UITextField!
    @IBOutlet weak var lbCPF: UITextField!
    @IBOutlet weak var lbNumero: UITextField!
    @IBOutlet weak var lbData: UITextField!
    @IBOutlet weak var lbCVV: UITextField!
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnConfirmar: UIButton!
    
    lazy var inputToolbar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        var nextButton : UIBarButtonItem = {
            let btn = UIBarButtonItem(title: "Avançar", style: .plain, target: self, action: #selector(nextPressed))
            btn.tintColor = AppConstants.ColorConstants.defaultGreen
            return btn
        }()
        
        var previousButton : UIBarButtonItem = {
            let btn = UIBarButtonItem(title: "Voltar", style: .plain, target: self, action: #selector(previousPressed))
            btn.tintColor = AppConstants.ColorConstants.defaultGreen
            return btn
        }()
        
        var spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton, previousButton, spaceButton, nextButton, spaceButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }()
    
    @objc func nextPressed() {
        if txtNumeroCartao.isFirstResponder {
            scrollView.scrollRectToVisible(txtMesCartao.frame, animated: true)
            txtMesCartao.becomeFirstResponder()
        } else if txtMesCartao.isFirstResponder {
            scrollView.scrollRectToVisible(txtCVVCartao.frame, animated: true)
            txtCVVCartao.becomeFirstResponder()
        } else if txtCVVCartao.isFirstResponder {
            scrollView.scrollRectToVisible(txtNomeTitular.frame, animated: true)
            txtNomeTitular.becomeFirstResponder()
        } else if txtNomeTitular.isFirstResponder {
            scrollView.scrollRectToVisible(txtCPF.frame, animated: true)
            txtCPF.becomeFirstResponder()
        }
    }
    
    @objc func previousPressed() {
        if txtCPF.isFirstResponder {
            scrollView.scrollRectToVisible(txtNomeTitular.frame, animated: true)
            txtNomeTitular.becomeFirstResponder()
        } else if txtNomeTitular.isFirstResponder {
            scrollView.scrollRectToVisible(txtCVVCartao.frame, animated: true)
            txtCVVCartao.becomeFirstResponder()
        } else if txtCVVCartao.isFirstResponder {
            scrollView.scrollRectToVisible(txtMesCartao.frame, animated: true)
            txtMesCartao.becomeFirstResponder()
        } else if txtMesCartao.isFirstResponder {
            scrollView.scrollRectToVisible(txtNumeroCartao.frame, animated: true)
            txtNumeroCartao.becomeFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cartaoView.layer.cornerRadius = 5.0
        btnConfirmar.layer.cornerRadius = 5.0
        
        txtNumeroCartao.delegate = self
        txtMesCartao.delegate = self
        txtCVVCartao.delegate = self
        txtNomeTitular.delegate = self
        txtCPF.delegate = self
        
        txtNumeroCartao.inputAccessoryView = inputToolbar
        txtMesCartao.inputAccessoryView = inputToolbar
        txtCVVCartao.inputAccessoryView = inputToolbar
        txtNomeTitular.inputAccessoryView = inputToolbar
        txtCPF.inputAccessoryView = inputToolbar
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"),
                                               object: txtNumeroCartao)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.currentFrame = self.view.bounds
    }
    
    @objc func textDidChange(){
        if txtNumeroCartao.text?.count == 19 {
            validateCard(number: txtNumeroCartao.text?.replacingOccurrences(of: " ", with: "") ?? "")
        }
    }
    
    @IBAction func confirmarClick(_ sender: Any) {
        if reserva != nil {
            performSegue(withIdentifier:
                "PagamentoToCompleteSegue", sender: self)
        } else if reservaLista != nil {
            performSegue(withIdentifier:
                "PagamentoReservaListaToCompleteSegue", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ConfirmacaoController {
            vc.reserva = reserva
        } else if let vc = segue.destination as? ConfirmacaoReservaListaController {
            vc.reserva = reservaLista
        }
    }
    
}

extension PagamentoController {
    
    func validateCard(number: String){
        if cardValidator.validate(string: number) {
            print(cardValidator.type(from: number)?.name)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if textField == txtNumeroCartao {
            lbNumero.text = (txtNumeroCartao.text! as NSString).replacingCharacters(in: range, with: string)
        } else if textField == txtMesCartao {
            lbData.text = (txtMesCartao.text! as NSString).replacingCharacters(in: range, with: string)
        } else if textField == txtCVVCartao {
            lbCVV.text = (txtCVVCartao.text! as NSString).replacingCharacters(in: range, with: string)
        } else if textField == txtNomeTitular {
            lbNome.text = (txtNomeTitular.text! as NSString).replacingCharacters(in: range, with: string)
        } else if textField == txtCPF {
            lbCPF.text = (txtCPF.text! as NSString).replacingCharacters(in: range, with: string)
        }
        
        return true
    }

    override func textFieldDidBeginEditing(_ textField: UITextField){
        super.textFieldDidBeginEditing(textField)
        activeField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
}
