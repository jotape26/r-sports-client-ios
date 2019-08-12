//
//  LogoffCell.swift
//  R Sports
//
//  Created by João Pedro Leite on 11/08/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class LogoffCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func logoffBtnClick(_ sender: Any) {
        FirebaseService.logoutUser()
    }
    
}
