//
//  PagamentoController.swift
//  R Sports
//
//  Created by João Pedro Leite on 07/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class PagamentoController: UIViewController {

    @IBOutlet weak var cartaoView: UIView!
    @IBOutlet weak var txtNumeroCartao: UITextField!
    @IBOutlet weak var txtMesCartao: UITextField!
    @IBOutlet weak var txtCVVCartao: UITextField!
    
    @IBOutlet weak var btnConfirmar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cartaoView.layer.cornerRadius = 5.0
        btnConfirmar.layer.cornerRadius = 5.0
        
        txtNumeroCartao.setBottomBorder(withColor: .lightGray)
        txtMesCartao.setBottomBorder(withColor: .lightGray)
        txtCVVCartao.setBottomBorder(withColor: .lightGray)
    }

}
