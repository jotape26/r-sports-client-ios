//
//  UIViewController+Extensions.swift
//  R Sports
//
//  Created by João Leite on 28/05/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

extension UIViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.removeInvalid()
    }
}

extension UIView {
    
    func startLoading() {
        DispatchQueue.main.async {
            let spinView = NVActivityIndicatorView(frame: CGRect(x: self.frame.midX - 5.0, y: self.frame.midY - 5.0, width: 10, height: 10), type: .ballRotateChase, color: AppConstants.ColorConstants.defaultGreen, padding: 30)
            spinView.startAnimating()
            self.addSubview(spinView)
        }
        
    }
    
    func stopLoading() {
        for view in self.subviews {
            if let spin = view as? NVActivityIndicatorView {
                spin.removeFromSuperview()
            }
        }
    }
}

class AlertBroker {
    static func showAlert(title: String? = nil, description: String? = nil, view: UIViewController) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}
