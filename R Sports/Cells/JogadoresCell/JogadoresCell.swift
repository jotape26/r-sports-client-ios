//
//  JogadoresCell.swift
//  R Sports
//
//  Created by João Leite on 09/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class JogadoresCell: UITableViewCell {

    @IBOutlet weak var loadingSpin: UIActivityIndicatorView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var stack: UIStackView!
    
    var btConvidar : UIButton = {
       let btn = UIButton(type: .custom)
        btn.setTitle("Convidar ao R Sports", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.06028468404, green: 0.3637206691, blue: 0.2629516992, alpha: 1), for: .normal)
        return btn
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        if btConvidar.isDescendant(of: stack) {
            btConvidar.removeFromSuperview()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configurarJogador(jogador: UserDTO) {
        
        if jogador.nome != nil {
            phoneLabel.text = jogador.nome
            self.loadingSpin.stopAnimating()
        } else {
            phoneLabel.text = jogador.telefone
            FirebaseService.getPlayerDetails(jogador: jogador, found: { (user) in
                self.phoneLabel.text = user.nome
                self.loadingSpin.stopAnimating()
            }) {
                self.phoneLabel.textColor = .lightGray
                self.stack.addArrangedSubview(self.btConvidar)
                self.loadingSpin.stopAnimating()
            }
        }
    }
    
}
