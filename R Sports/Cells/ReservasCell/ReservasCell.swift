//
//  ReservasCell.swift
//  R Sports
//
//  Created by João Leite on 02/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class ReservasCell: UITableViewCell {

    static let reuseIdentifier = "ReservasCell"
    
    @IBOutlet weak var lbQuadra: UILabel!
    @IBOutlet weak var lbData: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbValor: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
