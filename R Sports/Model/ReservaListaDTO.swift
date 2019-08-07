//
//  ReservaListaDTO.swift
//  R Sports
//
//  Created by João Pedro Leite on 06/08/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import ObjectMapper
import Firebase

class JogadoresServerDTO: ImmutableMappable {
    var statusPagamento : Bool?
    var user : DocumentReference?
    var userName : String?
    var valorAPagar: Double?
    
    required init(map: Map) throws {
        statusPagamento = try? map.value("statusPagamento")
        user = try? map.value("user")
        userName = try? map.value("userName")
        valorAPagar = try? map.value("valorAPagar")
    }
    
}

class ReservaListaDTO: ImmutableMappable {
    
    var dataHora : Date?
    var donoQuadraID : String?
    var nomeQuadra : String?
    var duracao : Int?
    var jogadores : [JogadoresServerDTO]?
    var primeiroJogador : DocumentReference?
    var status : String?
    var valorPago : Double?
    var docID : String?
    var quadraID : String?
    
    var quadra : QuadraDTO?

    required init(map: Map) throws {
        donoQuadraID = try? map.value("donoQuadraID")
        status = try? map.value("status")
        duracao = try? map.value("duracao")
        primeiroJogador = try? map.value("primeiroJogador")
        jogadores = try? map.value("jogadores")
        valorPago = try? map.value("valorPago")
        dataHora = try? map.value("dataHora")
        nomeQuadra = try? map.value("nomeQuadra")
        quadraID = try? map.value("quadraID")
    }
}
