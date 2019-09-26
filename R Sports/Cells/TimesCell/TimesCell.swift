//
//  TimesCell.swift
//  R Sports
//
//  Created by João Pedro Leite on 22/09/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class TimesCell: UITableViewCell {

    @IBOutlet weak var imgTime: UIImageView!
    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblJogadores: UILabel!
    @IBOutlet weak var lblHistorico: UILabel!
    
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
        imgTime.setRounded()
        imgTime.layer.borderWidth = 5.0
        imgTime.layer.borderColor = AppConstants.ColorConstants.highlightGreen.cgColor
    }
    
    func getTimeImage(docID: String) {
        FirebaseService.getTimeImage(docID: docID, success: { (image) in
            self.imgTime.image = image
        }) {
            self.imgTime.image = UIImage(named: "group-icon-large")
        }
    }
    
}
