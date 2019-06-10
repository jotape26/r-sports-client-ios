//
//  UITextField+Extensions.swift
//  R Sports
//
//  Created by João Leite on 28/05/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import UIKit

extension UITextField
{
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
            return phone
        }
        return ""
    }
    
    func setTextInvalid(){
        UIView.animate(withDuration: 1) {
            self.backgroundColor = .red
            self.layoutIfNeeded()
        }
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
