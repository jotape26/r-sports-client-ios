//
//  AuthController.swift
//  R Sports
//
//  Created by João Pedro Leite on 08/04/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class AuthController: UIViewController {

    @IBOutlet var controllerView: UIView!
    @IBOutlet weak var ballTrailing: NSLayoutConstraint!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        phoneText.delegate = self
//        txtSMSCode.delegate = self
        btnLogin.layer.cornerRadius = 5.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if FirebaseService.getCurrentUser() != nil {
            performSegue(withIdentifier: "AuthToMainSegue", sender: nil)
        } else {
            UIView.animate(withDuration: 1.5) {
                self.ballTrailing.constant = 100
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.5, animations: {
                    self.controllerView.alpha = 1.0
                })
            }
        }
    }


}


