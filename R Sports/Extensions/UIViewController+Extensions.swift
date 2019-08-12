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

extension UIButton {
    func addRightImage(image: UIImage, offset: CGFloat) {
        self.setImage(image, for: .normal)
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        self.imageView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset).isActive = true
//        self.titleLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
    }
}

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
    
    func startStandardLoading(){
        let act = UIActivityIndicatorView(style: .whiteLarge)
        act.frame = CGRect(x: self.frame.midX - 20, y: self.frame.midY - 20, width: 20, height: 20)
        self.addSubview(act)
    }
    
    func stopStandardLoading() {
        for view in self.subviews {
            if let spin = view as? UIActivityIndicatorView {
                spin.removeFromSuperview()
            }
        }
    }
    
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
