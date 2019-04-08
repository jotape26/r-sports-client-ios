//
//  QuadrasCell.swift
//  R Sports
//
//  Created by João Pedro Leite on 29/03/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import Cosmos

class QuadrasCell: UITableViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var imgQuadra: UIImageView!
    @IBOutlet weak var lbNomeQuadra: UILabel!
    @IBOutlet weak var lbEnderecoQuadra: UILabel!
    @IBOutlet weak var lbPrecoQuadra: UILabel!
    @IBOutlet weak var ratingQuadra: CosmosView!
    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        borderView.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func downloadImage(path: String?) {
        imageLoader.startAnimating()
        
        //Make Download Function
        
        if let path = path {
            FirebaseService.getCourtImage(path: path) { (courtImage) in
                self.imgQuadra.image = courtImage
            }
        } else {
            self.imgQuadra.image = nil
        }
        
        imageLoader.stopAnimating()
    }
    
}
