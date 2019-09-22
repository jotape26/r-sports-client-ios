//
//  JogadorTimeDTO.swift
//  R Sports
//
//  Created by João Pedro Leite on 22/09/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import ObjectMapper

class TimeDTO: ImmutableMappable {
    required init(map: Map) throws {
        nome = try? map.value("nome")
        jogadores = try? map.value("jogadores")
        partidas = try? map.value("partidas")
    }
    
    var nome: String?
    var jogadores: [JogadorTimeDTO]?
    var partidas: [String]?
    var timeID : String?
}

class JogadorTimeDTO: ImmutableMappable {
    var nome: String?
    var docRef : String?
    
    required init(map: Map) throws {
        nome = try? map.value("nome")
        docRef = try map.value("documentID")
    }
}
