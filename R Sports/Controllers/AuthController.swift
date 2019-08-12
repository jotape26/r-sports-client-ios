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
        btnLogin.layer.cornerRadius = 5.0
        
        if UserDefaults.standard.integer(forKey: "quadraLastUsedDistance") == 0 {
            UserDefaults.standard.set(50, forKey: "quadraLastUsedDistance")
            UserDefaults.standard.set(1, forKey: "quadraLastUsedRating")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if FirebaseService.getCurrentUser() != nil {
            self.view.startLoading()
            FirebaseService.retrieveUserDatabaseRef(uid: FirebaseService.getCurrentUser()!.phoneNumber!) { (user) in
                self.view.stopLoading()
                SharedSession.shared.currentUser = user
                self.performSegue(withIdentifier: "AuthToMainSegue", sender: nil)
            }
        } else {
            UIView.animate(withDuration: 1.5) {
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.5, animations: {
                    self.controllerView.alpha = 1.0
                })
            }
        }
    }


}


