//
//  PhoneService.swift
//  R Sports
//
//  Created by João Leite on 08/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class PhoneService {
    
    static func sendVerificationCode(phoneNumber: String,
                                     success: @escaping()->(),
                                     failure: @escaping(Error)->()){
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                failure(error)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            success()
        }
    }
}
