//
//  UIWindow+Extensions.swift
//  R Sports
//
//  Created by João Pedro Leite on 08/04/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

// UIWindow Extension from StackOverflow in order to display alerts and push ViewControllers without hassle.
// https://stackoverflow.com/questions/26667009/get-top-most-uiviewcontroller
public extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc : Any) -> UIViewController {
        
        if vc is UINavigationController {
            
            let navigationController = (vc as! UINavigationController)
            return UIWindow.getVisibleViewControllerFrom(vc: navigationController.visibleViewController ?? UIViewController())
            
        } else if vc is UITabBarController {
            
            let tabBarController = (vc as! UITabBarController)
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController ?? UIViewController())
            
        } else {
            
            let controller = (vc as! UIViewController)
            if let presentedViewController = controller.presentedViewController {
                
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController)
                
            } else {
                
                return controller;
            }
        }
    }
}
