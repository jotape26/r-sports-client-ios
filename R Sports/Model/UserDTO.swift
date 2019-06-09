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
    var email: String?
    var idade: Int?
    var genero: String?
    var posicao: String?
    var totalJogos: Int?
    var procuraJogos: Bool?
    var competitivade: String?
    var imagePath: String?
    
    required init(map: Map) throws {
        nome = try? map.value("userName")
        idade = try? map.value("userAge")
        email = try? map.value("userEmail")
        genero = try? map.value("userGender")
        posicao = try? map.value("userPosition")
        totalJogos = try? map.value("totalMatches")
        procuraJogos = try? map.value("searchingMatches")
        competitivade = try? map.value("competitivity")
        imagePath = try? map.value("userImage")
    }
}
