//
//  OnboardingPlaystyleController.swift
//  R Sports
//
//  Created by João Leite on 08/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class OnboardingPlaystyleController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnContinuarClick(_ sender: Any) {
        performSegue(withIdentifier: "PlaystyleToFinishSegue", sender: nil)
    }
    
}
