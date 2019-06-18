//
//  QuadraDTO.swift
//  R Sports
//
//  Created by João Pedro Leite on 29/03/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

class QuadraDTO : ImmutableMappable {
    var nome: String?
    var endereco: String?
    var cidade: String?
    var rating: Double?
    var preco: Double?
    var imagens: [String]?
    var distance: Double?
    var servicos : [String]?
    var documentID: String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    var location: CLLocation {
        return CLLocation(latitude: self.latitude ?? CLLocationDegrees(), longitude: self.longitude ?? CLLocationDegrees())
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        let dist = location.distance(from: self.location)
        distance = dist.magnitude
        return dist
    }
    
    required init(map: Map) throws {
        self.nome = try? map.value("nome")
        self.endereco = try? map.value("endereco")
        self.cidade = try? map.value("cidade")
        self.rating = try? map.value("rating")
        self.preco = try? map.value("preco")
        self.imagens = try? map.value("imagens")
        self.servicos = try? map.value("servicos")
        
        if let t = try? map.value("l") as [Double] {
            latitude = CLLocationDegrees(exactly: t[0]) ?? CLLocationDegrees()
            longitude = CLLocationDegrees(exactly: t[1]) ?? CLLocationDegrees()
        }
    }
}
