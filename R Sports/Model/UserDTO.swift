//
//  UserDTO.swift
//  R Sports
//
//  Created by João Leite on 27/05/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

class UserDTO: ImmutableMappable {
    
    var nome: String?
    var email: String?
    var idade: Date?
    var genero: String?
    var posicao: String?
    var totalJogos: Int?
    var procuraJogos: Bool?
    var competitivade: String?
    var imagePath: String?
    var telefone: String?
    var reservas: [String]?
    var times: [String: String]?
    var gols: Int?
    var assistencias: Int?
    var timesTemp: [String]?
    
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
        reservas = try? map.value(ProfileConstants.RESERVAS)
        times = try? map.value("times")
        timesTemp = try? map.value("timesTemp")
        gols = try? map.value("gols")
        assistencias = try? map.value("assistencias")
    }
}

struct ProfileConstants {
    static let NAME = "userName"
    static let AGE = "userDOB"
    static let EMAIL = "userEmail"
    static let GENDER = "userGender"
    static let POSITION = "userPosition"
    static let MATCHES = "totalMatches"
    static let SEARCHING_GAMES = "searchingMatches"
    static let COMPETITIVITY = "competitivity"
    static let IMAGEPATH = "userImage"
    static let RESERVAS = "reservas"
}

