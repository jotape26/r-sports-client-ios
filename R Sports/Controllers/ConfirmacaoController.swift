//
//  ConfirmacaoController.swift
//  R Sports
//
//  Created by João Pedro Leite on 07/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class ConfirmacaoController: UIViewController {

    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var btnVoltar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imgCheck.image = imgCheck.image?.withRenderingMode(.alwaysTemplate)
        imgCheck.tintColor = #colorLiteral(red: 0.07843137255, green: 0.462745098, blue: 0.3333333333, alpha: 1)
        btnVoltar.layer.cornerRadius = 5.0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnVoltarClick(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
