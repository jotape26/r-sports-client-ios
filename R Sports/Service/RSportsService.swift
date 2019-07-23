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
    
    static func processNewReservation(reservaID : String) {
        
        let parameters = ["documentID" : reservaID]
        
        Alamofire.request("https://r-sports-services.herokuapp.com/notifyUsers", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { (dataRes) in
            print(dataRes.data?.description)
        }
    }
    
}
