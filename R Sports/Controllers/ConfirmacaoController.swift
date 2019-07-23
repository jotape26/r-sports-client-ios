//
//  ConfirmacaoController.swift
//  R Sports
//
//  Created by João Pedro Leite on 07/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class ConfirmacaoController: UIViewController {
    
    var reserva : ReservaDTO!

    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var btnVoltar: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imgCheck.image = imgCheck.image?.withRenderingMode(.alwaysTemplate)
        imgCheck.tintColor = AppConstants.ColorConstants.defaultGreen
        btnVoltar.layer.cornerRadius = 5.0
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Fazendo a Reserva..."
        self.view.startLoading()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FirebaseService.createReserva(reserva: reserva, success: {
            self.navigationItem.title = nil
            self.view.stopLoading()
            UIView.animate(withDuration: 0.3, animations: {
                self.imgCheck.alpha = 1
                self.lblTitle.alpha = 1
                self.lblMessage.alpha = 1
                self.btnVoltar.alpha = 1
            })
        }) {
            self.navigationItem.title = "Erro"
            self.view.stopLoading()
            UIView.animate(withDuration: 0.3, animations: {
                self.imgCheck.alpha = 1
                self.lblTitle.alpha = 1
                self.lblMessage.alpha = 1
                self.btnVoltar.alpha = 1
            })
        }
    }
    
    @IBAction func btnVoltarClick(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
