//
//  MainTabController.swift
//  R Sports
//
//  Created by João Pedro Leite on 08/04/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import GoogleSignIn

class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectedIndex = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.title = tabBar.selectedItem?.title
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func testButton(_ sender: Any) {
        FirebaseService.logoutUser()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.title = item.title
    }
}
