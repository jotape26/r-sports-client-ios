//
//  AlertsHelper.swift
//  R Sports
//
//  Created by João Pedro Leite on 26/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import SwiftMessages

class AlertsHelper {
    
    static func showErrorMessage(message: String){
        SwiftMessages.show {
            let messageView = MessageView.viewFromNib(layout: .messageView)
            messageView.configureTheme(Theme.error)
            messageView.configureIcon(withSize: CGSize(width: 0, height: 0))
            messageView.titleLabel?.text = nil
            messageView.bodyLabel?.text = message
            messageView.button?.removeFromSuperview()
            return messageView
        }
    }
    
}
