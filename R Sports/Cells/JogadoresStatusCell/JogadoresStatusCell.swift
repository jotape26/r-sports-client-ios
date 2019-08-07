//
//  JogadoresStatusCell.swift
//  R Sports
//
//  Created by João Pedro Leite on 07/08/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class JogadoresStatusCell: UICollectionViewCell {

    @IBOutlet weak var lbNome: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgStatus.image = nil
    }

}
