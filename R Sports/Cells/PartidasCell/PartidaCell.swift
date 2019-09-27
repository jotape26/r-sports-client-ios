//
//  PartidaCell.swift
//  R Sports
//
//  Created by João Pedro Leite on 26/09/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class PartidaCell: UITableViewCell {

    @IBOutlet weak var txtNomePartida: UILabel!
    @IBOutlet weak var txtDataPartida: UILabel!
    @IBOutlet weak var txtNomeQuadra: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
