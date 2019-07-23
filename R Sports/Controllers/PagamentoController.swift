//
//  PagamentoController.swift
//  R Sports
//
//  Created by João Pedro Leite on 07/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class PagamentoController: UIViewController {

    var reserva : ReservaDTO!
    
    let cardValidator = CreditCardValidator()
    @IBOutlet weak var cartaoView: UIView!
    @IBOutlet weak var txtNumeroCartao: SwiftMaskTextfield!
    @IBOutlet weak var txtMesCartao: UITextField!
    @IBOutlet weak var txtCVVCartao: UITextField!
    
    @IBOutlet weak var btnConfirmar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cartaoView.layer.cornerRadius = 5.0
        btnConfirmar.layer.cornerRadius = 5.0
        
        txtNumeroCartao.setBottomBorder(withColor: .lightGray)
        txtNumeroCartao.delegate = self
        txtMesCartao.setBottomBorder(withColor: .lightGray)
        txtCVVCartao.setBottomBorder(withColor: .lightGray)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"),
                                               object: txtNumeroCartao)
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
}
