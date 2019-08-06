//
//  NoQuadrasCell.swift
//  R Sports
//
//  Created by João Pedro Leite on 06/08/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class NoQuadrasCell: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgIcon.image = imgIcon.image?.withRenderingMode(.alwaysTemplate)
        imgIcon.tintColor = #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
