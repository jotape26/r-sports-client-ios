//
//  ServicoController.swift
//  R Sports
//
//  Created by João Pedro Leite on 12/08/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class ServicoController: UIViewController {

    @IBOutlet weak var imgServico: UIImageView!
    @IBOutlet weak var lbTituloServico: UILabel!
    @IBOutlet weak var lbDescricaoServico: UILabel!
    
    var servico : ServicoQuadra!
    
    class func create(servico : ServicoQuadra) -> ServicoController {
        let contr = ServicoController(nibName: "ServicoController", bundle: nil)
        
        contr.servico = servico
        return contr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imgServico.image = servico.getImage()
        lbTituloServico.text = servico.type.rawValue.capitalized
        lbDescricaoServico.text = servico.description
    }
}
