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
    
    static func showMessage(message: String){
        SwiftMessages.show {
            let messageView = MessageView.viewFromNib(layout: .messageView)
            messageView.configureTheme(Theme.success)
            messageView.configureIcon(withSize: CGSize(width: 0, height: 0))
            messageView.titleLabel?.text = nil
            messageView.bodyLabel?.text = message
            messageView.button?.removeFromSuperview()
            return messageView
        }
    }
    
    static func showSystemAlert(title: String? = nil, description: String? = nil, view: UIViewController) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
}
