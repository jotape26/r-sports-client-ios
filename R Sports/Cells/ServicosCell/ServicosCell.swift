//
//  ServicosCell.swift
//  R Sports
//
//  Created by João Pedro Leite on 08/08/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class ServicosCell: UITableViewCell {

    @IBOutlet weak var imgServico: UIImageView!
    @IBOutlet weak var lbServicoTitle: UILabel!
    @IBOutlet weak var lbServicoDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
