//
//  QuadraDTO.swift
//  R Sports
//
//  Created by João Pedro Leite on 29/03/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import FirebaseFirestore
import ObjectMapper
import CoreLocation

class QuadraDTO : ImmutableMappable {
    var nome: String?
    var endereco: String?
    var numeroEndereco : String?
    var cidade: String?
    var rating: Double?
    var preco: [Double]?
    var imagens: [String]?
    var distance: Double {
        get {
            guard let userLocation = SharedSession.shared.currentLocation else { return 0 }
            guard let quadraLocation = self.location else { return 0 }
            let dist = userLocation.distance(from: quadraLocation)
            return dist
        }
    }
    var servicos : [String]?
    var documentID: String?
    var coordinates = [Double]()
    var donoQuadraID : String?
    var telefone : String?
    
    var location: CLLocation? {
        get{
            guard !coordinates.isEmpty, coordinates.count == 2 else { return nil }
            return CLLocation(latitude: coordinates[0], longitude: coordinates[1])
        }
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        guard let location = self.location else { return 0 }
        let dist = location.distance(from: location)
        return dist
    }
    
    required init(map: Map) throws {
        self.nome = try? map.value("nome")
        self.endereco = try? map.value("endereco")
        self.numeroEndereco = try? map.value("number")
        self.cidade = try? map.value("cidade")
        self.rating = try? map.value("rating")
        self.preco = try? map.value("precos")
        self.imagens = try? map.value("imagens")
        self.servicos = try? map.value("servicos")
        self.donoQuadraID = try? map.value("userId")
        self.telefone = try? map.value("telefone")
        
        if let t = try? map.value("l") as [Double] {
            t.forEach { (cord) in
                coordinates.append(cord)
            }
        }
    }
    
    func getTodayPrice() -> Double? {
        let cal = Calendar.current
        return preco?[cal.component(.weekday, from: Date()) - 1]
    }
}
