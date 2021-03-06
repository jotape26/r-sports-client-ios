//
//  MainTabController.swift
//  R Sports
//
//  Created by João Pedro Leite on 08/04/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleSignIn

class MainTabController: UITabBarController {
    
    var timer : Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SharedSession.shared.reloadUser(done: {})
        selectedIndex = 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.title = tabBar.selectedItem?.title
        registerForRemoteNotification()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.title = item.title
    }
    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        else {
            DispatchQueue.main.async {
                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}
