//
//  DadosUsuarioCell.swift
//  R Sports
//
//  Created by João Pedro Leite on 11/08/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class DadosUsuarioCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbTitulo: UILabel!
    @IBOutlet weak var lbDetalhe: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
