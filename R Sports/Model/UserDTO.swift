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
    var telefone: String?
    
    init(){}
    
    required init(map: Map) throws {
        nome = try? map.value(ProfileConstants.NAME)
        idade = try? map.value(ProfileConstants.AGE)
        email = try? map.value(ProfileConstants.EMAIL)
        genero = try? map.value(ProfileConstants.GENDER)
        posicao = try? map.value(ProfileConstants.POSITION)
        totalJogos = try? map.value(ProfileConstants.POSITION)
        procuraJogos = try? map.value(ProfileConstants.SEARCHING_GAMES)
        competitivade = try? map.value(ProfileConstants.COMPETITIVITY)
        imagePath = try? map.value(ProfileConstants.IMAGEPATH)
    }
}

struct ProfileConstants {
    static let NAME = "userName"
    static let AGE = "userAge"
    static let EMAIL = "userEmail"
    static let GENDER = "userGender"
    static let POSITION = "userPosition"
    static let MATCHES = "totalMatches"
    static let SEARCHING_GAMES = "searchingMatches"
    static let COMPETITIVITY = "competitivity"
    static let IMAGEPATH = "userImage"
}

