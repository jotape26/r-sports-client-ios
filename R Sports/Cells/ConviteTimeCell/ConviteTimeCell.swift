//
//  ConviteTimeCell.swift
//  R Sports
//
//  Created by João Pedro Leite on 22/09/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class ConviteTimeCell: UITableViewCell {
    
    @IBOutlet weak var imgTime: UIImageView!
    @IBOutlet weak var nomeTime: UILabel!
    @IBOutlet weak var lblConvite: UILabel!
    @IBOutlet weak var btnRecusar: UIButton!
    @IBOutlet weak var btnAceitar: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgTime.image = nil
        imgTime.setRounded()
        imgTime.layer.borderWidth = 5.0
        imgTime.layer.borderColor = AppConstants.ColorConstants.highlightGreen.cgColor
    }
    
}
