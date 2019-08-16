//
//  UITextField+Extensions.swift
//  R Sports
//
//  Created by João Leite on 28/05/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func useDoneToolbar() {
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(inputToolbarDonePressed))
        
        doneButton.tintColor = AppConstants.ColorConstants.defaultGreen
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        self.inputAccessoryView = toolbar
    }
    
    @objc private func inputToolbarDonePressed() {
        self.endEditing(true)
    }
    
    func setBottomBorder(withColor color: UIColor)
    {
        self.borderStyle = .none
        self.backgroundColor = UIColor.clear
        let width: CGFloat = 1.0
        
        let borderLine = UIView(frame: CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width))
        borderLine.backgroundColor = color
        self.addSubview(borderLine)
    }
    
    func formatToPhone() -> String {
        if var phone = self.text {
            phone = phone.replacingOccurrences(of: " ", with: "")
            phone = phone.replacingOccurrences(of: "(", with: "")
            phone = phone.replacingOccurrences(of: ")", with: "")
            phone = phone.replacingOccurrences(of: "-", with: "")
            phone = "+\(phone)"
            return phone
        }
        return ""
    }
    
    func setTextInvalid(){
        
        let imageView = UIImageView(image: UIImage(named: "icons8-attention"))
        
        let frame = self.textInputView.frame
        
        let size = frame.height - 5
        
        imageView.frame = CGRect(x: frame.minX, y: frame.minY, width: size, height: size)
        
        UIView.animate(withDuration: 1) {
            self.rightViewMode = .always
            self.rightView = imageView
        }
    }
    
    func removeInvalid() {
        self.rightView = nil
        self.rightViewMode = .never
    }
}

extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}
