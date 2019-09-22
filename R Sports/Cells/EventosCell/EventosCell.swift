//
//  EventosCell.swift
//  R Sports
//
//  Created by João Pedro Leite on 16/09/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class EventosCell: UITableViewCell {

    @IBOutlet weak var lblPreco: UILabel!
    @IBOutlet weak var lblNomeEvento: UILabel!
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var lblPosicao: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
