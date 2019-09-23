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
    
    init(){}
    
    required init(map: Map) throws {
        nome = try? map.value("nome")
        jogadores = try? map.value("jogadores")
        partidas = try? map.value("partidas")
    }
    
    var nome: String?
    var jogadores: [JogadorTimeDTO]?
    var partidas: [String]?
    var timeID : String?
    
    func getCreationData() -> [String: Any] {
        
        var jogadoresArr : [[String:Any]] = [[:]]
        
        for (index, jogador) in (jogadores ?? []).enumerated() {
            var jog : [String : Any] = [:]
            
            if index == 0 {
                guard let phone = jogador.telefone, let nome = jogador.nome else { return [:] }
                jog.updateValue(phone, forKey: "telefone")
                jog.updateValue(nome, forKey: "nome")
                jog.updateValue(false, forKey: "pendente")
            } else {
                if let phone = jogador.telefone {
                    jog.updateValue(phone, forKey: "telefone")
                    jog.updateValue(true, forKey: "pendente")
                }
            }
            
            if !jog.isEmpty {
                jogadoresArr.append(jog)
            }
        }
        
        
        let params : [String: Any] =  ["nome" : self.nome ?? "",
                                       "partidas": [],
                                       "jogadores" : jogadoresArr]
        
        return params
    }
}

class JogadorTimeDTO: ImmutableMappable {
    var nome: String?
    var telefone : String?
    var pendente: Bool = true
    var docRef : String?
    
    init() {}
    
    required init(map: Map) throws {
        nome = try? map.value("nome")
        telefone = try? map.value("telefone")
        pendente = (try? map.value("pendente")) ?? true
        docRef = try map.value("documentID")
    }
}
