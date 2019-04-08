//
//  QuadraDTO.swift
//  R Sports
//
//  Created by João Pedro Leite on 29/03/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import CoreLocation
import ObjectMapper

class QuadraDTO : ImmutableMappable {
    var nome: String?
    var endereco: String?
    var rating: Double?
    var preco: Double?
    var imagePath: String?
    var distance: Double?
    
    required init(map: Map) throws {
        self.nome = try? map.value("nome")
        self.endereco = try? map.value("endereco")
        self.rating = try? map.value("rating")
        self.preco = try? map.value("preco")
        self.imagePath = try? map.value("imagemPath")
        
        DispatchQueue.main.async {
            self.calculateDistance()
        }
    }
    
    func calculateDistance(){
        if let userLocation = CLLocationManager().location, let courtAddress = self.endereco {
            let locationHelper = CLGeocoder()
            locationHelper.geocodeAddressString(courtAddress) { (marks, err) in
                if err != nil {
                    self.distance = nil
                }
                
                if let mark = marks {
                    if !mark.isEmpty {
                        guard let courtLocation = mark.first?.location else {
                            self.distance = nil
                            return
                        }
                        let distance = userLocation.distance(from: courtLocation)
                        self.distance = distance
                    } else {
                        self.distance = nil
                    }
                } else {
                    self.distance = nil
                }
            }
        } else {
            self.distance = nil
        }
    }
}
