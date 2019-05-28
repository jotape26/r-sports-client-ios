//
//  QuadraDTO.swift
//  R Sports
//
//  Created by João Pedro Leite on 29/03/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import ObjectMapper

class QuadraDTO : ImmutableMappable {
    var nome: String?
    var endereco: String?
    var cidade: String?
    var rating: Double?
    var preco: Double?
    var imagePath: String?
    var distance: Double?
    
    required init(map: Map) throws {
        self.nome = try? map.value("nome")
        self.endereco = try? map.value("endereco")
        self.cidade = try? map.value("cidade")
        self.rating = try? map.value("rating")
        self.preco = try? map.value("preco")
        self.imagePath = try? map.value("imagemPath")
    }
}
