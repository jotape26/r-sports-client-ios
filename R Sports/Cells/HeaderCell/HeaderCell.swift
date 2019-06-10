//
//  HeaderCell.swift
//  R Sports
//
//  Created by João Leite on 09/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconStack: UIStackView!
    @IBOutlet weak var iconStackWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        iconStack.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    
    func addImageToIconStack(image: UIImage) {
        let image = UIImageView(image: image)
        image.contentMode = .scaleAspectFit
        image.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        iconStack.addArrangedSubview(image)
        iconStackWidth.constant += 35
    }
    
}
