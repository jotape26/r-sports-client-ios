//
//  SharedSession.swift
//  R Sports
//
//  Created by João Leite on 27/05/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class SharedSession: NSObject {
    
    private let locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var currentUser : UserDTO?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    static var shared : SharedSession = {
        return SharedSession()
    }()
    
    func reloadUser(done: @escaping()->()) {
        FirebaseService.retrieveUserDatabaseRef(uid: FirebaseService.getCurrentUser()!.phoneNumber!) { (user) in
            SharedSession.shared.currentUser = user
            done()
        }
    }
}

extension SharedSession: CLLocationManagerDelegate {
    func requestUserLocation(){
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied, .restricted:
            print("Location not authorized")
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            return
        }
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        self.currentLocation = locationManager.location
    }
}
