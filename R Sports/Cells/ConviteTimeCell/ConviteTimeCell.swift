//
//  ConviteTimeCell.swift
//  R Sports
//
//  Created by João Pedro Leite on 22/09/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

protocol TimeUpdateDelegate {
    func didUpdateTeams()
    func willUpdateTeams()
}

class ConviteTimeCell: UITableViewCell {
    
    @IBOutlet weak var imgTime: UIImageView!
    @IBOutlet weak var nomeTime: UILabel!
    @IBOutlet weak var lblConvite: UILabel!
    @IBOutlet weak var btnRecusar: UIButton!
    @IBOutlet weak var btnAceitar: UIButton!
    
    var timeID = ""
    var delegate : TimeUpdateDelegate?
    
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
        timeID = ""
        imgTime.image = nil
        imgTime.setRounded()
        imgTime.layer.borderWidth = 5.0
        imgTime.layer.borderColor = AppConstants.ColorConstants.highlightGreen.cgColor
    }
    
    @IBAction func recusarClick(_ sender: Any) {
        self.delegate?.willUpdateTeams()
        RSportsService.refuseTeamInvite(timeID: timeID, success: {
            self.delegate?.didUpdateTeams()
        }) {
            AlertsHelper.showErrorMessage(message: "Erro de comunicação com o sistema, tente novamente.")
        }
    }
    @IBAction func aceitarClick(_ sender: Any) {
        self.delegate?.willUpdateTeams()
        RSportsService.acceptTeamInvite(timeID: timeID, success: {
            self.delegate?.didUpdateTeams()
        }) {
            AlertsHelper.showErrorMessage(message: "Erro de comunicação com o sistema, tente novamente.")
        }
    }
}
