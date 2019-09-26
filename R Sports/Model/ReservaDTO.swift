//
//  ReservaDTO.swift
//  R Sports
//
//  Created by João Pedro Leite on 10/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import ObjectMapper

class CriacaoReservaDTO {
    var quadra: QuadraDTO!
    var data: Date!
    var duracao: Int!
    var time: TimeDTO?
    
    init(quadra: QuadraDTO, data: Date, duracao: Int) {
        self.quadra = quadra
        self.data = data
        self.duracao = duracao
    }
    
    func getExportData() -> [String : Any] {
        
        guard let dataHora = data else { return [:] }
        guard let donoQuadraID = quadra?.donoQuadraID else { return [:] }
        guard let quadraID = quadra?.documentID else { return [:] }
        guard let user = FirebaseService.getDocumentReference() else { return [:] }
        guard let nome = quadra?.nome else { return [:] }
        guard let preco = quadra?.getTodayPrice() else { return [:] }
        
        var exportData = [String : Any]()
        if let selTime = time {
            
            let valor = preco / Double(selTime.getJogadoresConfirmedNumber())
            
            exportData = ["dataHora" : dataHora,
                          "duracao" : duracao!,
                          "donoQuadraID" : donoQuadraID,
                          "quadraID" : quadraID,
                          "primeiroJogador" : user,
                          "timeID" : selTime.timeID!,
                          "singlePayer" : false,
                          "status" : "Pendente",
                          "valorTotal" : preco,
                          "valorPago": valor,
                          "nomeQuadra" : nome]
        } else {
            exportData = ["dataHora" : dataHora,
                          "duracao" : duracao!,
                          "donoQuadraID" : donoQuadraID,
                          "quadraID" : quadraID,
                          "primeiroJogador" : user,
                          "timeID" : "",
                          "singlePayer" : true,
                          "status" : "Pago",
                          "valorTotal" : preco,
                          "valorPago": preco,
                          "nomeQuadra" : nome]
        }
        
        return exportData
    }
}

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
}
