//
//  UserDTO.swift
//  R Sports
//
//  Created by João Leite on 27/05/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import ObjectMapper

class UserDTO: ImmutableMappable {
    
    var nome: String?
    var idade: Int?
    var genero: String?
    var posicao: String?
    var totalJogos: Int?
    var procuraJogos: Bool?
    var competitivade: String?
    
    required init(map: Map) throws {
        nome = try? map.value("nome")
        idade = try? map.value("idade")
        genero = try? map.value("genero")
        posicao = try? map.value("posicao")
        totalJogos = try? map.value("totalJogos")
        procuraJogos = try? map.value("procuraJogos")
        competitivade = try? map.value("competitividade")
    }
}
