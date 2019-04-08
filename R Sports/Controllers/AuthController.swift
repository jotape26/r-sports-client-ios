//
//  AuthController.swift
//  R Sports
//
//  Created by João Pedro Leite on 08/04/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import GoogleSignIn

class AuthController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var googleSignButton: GIDSignInButton!
    @IBOutlet var controllerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self
        googleSignButton.style = .wide
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if FirebaseService.getCurrentUser() != nil {
            performSegue(withIdentifier: "AuthToMainSegue", sender: nil)
        } else {
            UIView.animate(withDuration: 0.5) {
                self.controllerView.alpha = 1.0
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
