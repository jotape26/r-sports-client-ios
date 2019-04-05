//
//  QuadrasCell.swift
//  R Sports
//
//  Created by João Pedro Leite on 29/03/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import RatingControl

class QuadrasCell: UITableViewCell {

    @IBOutlet weak var imgQuadra: UIImageView!
    @IBOutlet weak var lbNomeQuadra: UILabel!
    @IBOutlet weak var lbEnderecoQuadra: UILabel!
    @IBOutlet weak var lbPrecoQuadra: UILabel!
    @IBOutlet weak var ratingQuadra: RatingControl!
    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func downloadImage(url: String) {
        imageLoader.startAnimating()
        
        //Make Download Function
        
        imageLoader.stopAnimating()
    }
    
}
