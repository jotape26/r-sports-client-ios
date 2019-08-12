//
//  ServicosCollectionCell.swift
//  R Sports
//
//  Created by João Pedro Leite on 12/08/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class ServicosCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgServico: UIImageView!
    @IBOutlet weak var lbServico: UILabel!
    @IBOutlet weak var imgBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgBackgroundView.setRounded()
    }
}
