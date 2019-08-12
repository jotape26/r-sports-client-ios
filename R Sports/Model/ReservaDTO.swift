//
//  ReservaDTO.swift
//  R Sports
//
//  Created by João Pedro Leite on 10/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

class ReservaDTO: ImmutableMappable {
    
    var quadra: QuadraDTO?
    var data: Date?
    var jogadoresRef : [DocumentReference]?
    var jogadores: [UserDTO]?
    
    init(quadra: QuadraDTO, data: Date) {
        self.quadra = quadra
        self.data = data
        self.jogadores = []
    }
    
    required init(map: Map) throws {
        self.quadra = try? map.value("quadra")
        self.data = try? map.value("data")
        self.jogadoresRef = try? map.value("jogadores")
    }
    
    func addJogador(jogador: UserDTO) {
        jogadores?.insert(jogador, at: 0)
    }
    func getJogadores() -> [UserDTO] {
        return jogadores ?? []
    }
    
    func getExportData() -> [String : Any] {
        
        guard let dataHora = data else { return [:] }
        guard let donoQuadraID = quadra?.donoQuadraID else { return [:] }
        guard let quadraID = quadra?.documentID else { return [:] }
        guard let user = FirebaseService.getDocumentReference() else { return [:] }
        guard let nome = quadra?.nome else { return [:] }
        guard let preco = quadra?.preco else { return [:] }
        let valor = preco / Double(jogadores!.count)

        var exportData : [String : Any] = ["dataHora" : dataHora,
                                           "donoQuadraID" : donoQuadraID,
                                           "quadraID" : quadraID,
                                           "duracao" : 1,
                                           "primeiroJogador" : user,
                                           "status" : "Pendente",
                                           "valorTotal" : preco,
                                           "valorPago": valor,
                                           "nomeQuadra" : nome]
        
        var jogadorData = [[String : Any]]()
        jogadores?.forEach { (jogador) in
            if jogador.telefone! == FirebaseService.getCurrentUser()!.phoneNumber! {
                jogadorData.append(["statusPagamento": true,
                                    "user" : user,
                                    "valorAPagar" : valor,
                                    "userName" : jogador.nome!])
            } else {
                jogadorData.append(["telefoneTemp" : jogador.telefone!,
                                    "statusPagamento" : false])
            }
        }
        
        exportData.updateValue(jogadorData, forKey: "jogadores")
        
        return exportData
    }
    
}
