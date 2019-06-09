//
//  QuadrasCell.swift
//  R Sports
//
//  Created by João Pedro Leite on 29/03/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import CoreLocation
import Cosmos

class QuadrasCell: UITableViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var imgQuadra: UIImageView!
    @IBOutlet weak var lbNomeQuadra: UILabel!
    @IBOutlet weak var lbEnderecoQuadra: UILabel!
    @IBOutlet weak var lbPrecoQuadra: UILabel!
    @IBOutlet weak var lbDistancia: UILabel!
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

        
        //Make Download Function
        
        if let path = path {
            imageLoader.startAnimating()
            FirebaseService.getCourtImage(path: path, success: { (courtImage) in
                self.imgQuadra.image = courtImage
                self.imageLoader.stopAnimating()
            }, failure: {
                self.imageLoader.stopAnimating()
            })
        } else {
            self.imgQuadra.image = nil
        }
    }
    
//    func getDistanceBetween(userLocation: CLLocation?, courtAddress: String?) {
//        if let userLocation = userLocation, let courtAddress = courtAddress {
//            let locationHelper = CLGeocoder()
//            locationHelper.geocodeAddressString(courtAddress) { (marks, err) in
//                if err != nil {
//                    self.lbDistancia.text = nil
//                }
//
//                if let mark = marks {
//                    if !mark.isEmpty {
//                        guard let courtLocation = mark.first?.location else {
//                            self.lbDistancia.text = nil
//                            return
//                        }
//                        let distance = userLocation.distance(from: courtLocation)
//                        self.lbDistancia.text = "\(Int(distance))m"
//                    } else {
//                        self.lbDistancia.text = nil
//                    }
//                } else {
//                    self.lbDistancia.text = nil
//                }
//            }
//        } else {
//            self.lbDistancia.text = nil
//        }
//    }
    
}
