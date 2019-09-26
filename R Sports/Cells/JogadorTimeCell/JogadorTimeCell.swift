//
//  JogadorTimeCell.swift
//  R Sports
//
//  Created by João Pedro Leite on 26/09/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class JogadorTimeCell: UITableViewCell {

    @IBOutlet weak var txtNome: UILabel!
    @IBOutlet weak var txtPartidas: UILabel!
    @IBOutlet weak var txtGols: UILabel!
    @IBOutlet weak var txtAssistencias: UILabel!
    @IBOutlet weak var lblDisclaimerHeight: NSLayoutConstraint!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var statsHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        statsHeight.constant = 50
        statsView.isHidden = false
        lblDisclaimerHeight.constant = 0
    }
    
    func playerStillPending(){
        statsHeight.constant = 0
        statsView.isHidden = true
        lblDisclaimerHeight.constant = 25
    }
    
}
