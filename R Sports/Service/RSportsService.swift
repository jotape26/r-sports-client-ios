//
//  RSportsService.swift
//  R Sports
//
//  Created by João Pedro Leite on 22/07/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import Alamofire

class RSportsService {
    
    static func createNewTime(timeID : String,
                            success : @escaping()->()) {
        
        let parameters = ["timeID" : timeID]
        
        Alamofire.request("https://r-sports-services.herokuapp.com/createNewTeam", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { (dataRes) in
            print(dataRes.data?.description as Any)
            success()
        }
    }
    
    static func refuseTeamInvite(timeID : String,
                            success : @escaping()->(),
                            failure : @escaping()->()) {
        
        var parameters = ["timeID" : timeID]
        if let phone = SharedSession.shared.currentUser?.telefone {
            parameters.updateValue(phone, forKey: "userPhone")
        }
        
        Alamofire.request("https://r-sports-services.herokuapp.com/refuseTeamInvite", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { (dataRes) in
            print(dataRes.data?.description as Any)
            if dataRes.error != nil {
                failure()
            } else {
                SharedSession.shared.currentUser?.timesTemp = SharedSession.shared.currentUser?.timesTemp?.filter({$0 != timeID})
                
                FirebaseService.setUserData(data: ["timesTemp": SharedSession.shared.currentUser!.timesTemp!])
                success()
            }
        }
    }
    
    static func acceptTeamInvite(timeID : String,
                            success : @escaping()->(),
                            failure : @escaping()->()) {
        
        var parameters = ["timeID" : timeID]
        if let phone = SharedSession.shared.currentUser?.telefone {
            parameters.updateValue(phone, forKey: "userPhone")
        }
        
        Alamofire.request("https://r-sports-services.herokuapp.com/acceptTeamInvite", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { (dataRes) in
            print(dataRes.data?.description as Any)
            
            if dataRes.error != nil {
                failure()
            } else {
                SharedSession.shared.currentUser?.timesTemp = SharedSession.shared.currentUser?.timesTemp?.filter({$0 != timeID})
                
                FirebaseService.setUserData(data: ["timesTemp": SharedSession.shared.currentUser!.timesTemp!])
                success()
            }
        }
    }
    
    static func notifyUsers(reservaID : String,
                            success : @escaping()->()) {
        
        let parameters = ["documentID" : reservaID]
        
        Alamofire.request("https://r-sports-services.herokuapp.com/notifyUsers", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { (dataRes) in
            print(dataRes.data?.description as Any)
            success()
        }
    }
    
    static func processNewReservation(reservaID : String) {
        
        let parameters = ["documentID" : reservaID]
        
        Alamofire.request("https://r-sports-services.herokuapp.com/processReservation", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { (dataRes) in
            print(dataRes.data?.description as Any)
        }
    }
    
    static func registerPayment(reservaID : String, userPhone: String, success : @escaping()->(), failure: @escaping()->()) {
        
        let parameters = ["documentID" : reservaID,
                          "userPhone": userPhone]
        
        Alamofire.request("https://r-sports-services.herokuapp.com/registerPayment", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { (dataRes) in
            
            if dataRes.error != nil {
                failure()
            } else {
                print(dataRes.data?.description as Any)
                success()
            }
            
        }
    }
}
