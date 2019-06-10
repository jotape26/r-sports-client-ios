//
//  UIViewController+Extensions.swift
//  R Sports
//
//  Created by João Leite on 28/05/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func useGif() {
        
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "app_joao", withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        let imageView2 = UIImageView(image: advTimeGif)
        imageView2.frame = CGRect(x: self.view.frame.midX - 150, y: self.view.frame.midY - 150, width: 150.0, height: 150.0)
        imageView2.tag = 99999
        view.addSubview(imageView2)
    }
    
    func stopGif() {
        self.view.subviews.forEach { (view) in
            if let view = view as? UIImageView {
                if view.tag == 99999 {
                    view.removeFromSuperview()
                }
            }
        }
    }
}

extension UIView {
    func startLoading(){
        DispatchQueue.main.async {
            let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
            
            activityIndicator.sizeThatFits(CGSize(width: 50, height: 50))
            activityIndicator.center = self.center;
            activityIndicator.hidesWhenStopped = true;
            activityIndicator.style = .gray;
            self.addSubview(activityIndicator);
            
            activityIndicator.startAnimating();
        }
    }
    
    func stopLoading(){
        for view in self.subviews {
            if let spin = view as? UIActivityIndicatorView {
                DispatchQueue.main.async {
                    spin.stopAnimating()
                    spin.removeFromSuperview()
                }
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
