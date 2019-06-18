//
//  ReservaDTO.swift
//  R Sports
//
//  Created by João Pedro Leite on 10/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation

class ReservaDTO {
    
    private var quadra: QuadraDTO
    private var data: Date
    private var jogadores: [UserDTO]
    
    init(quadra: QuadraDTO, data: Date) {
        self.quadra = quadra
        self.data = data
        self.jogadores = []
    }
    
    func addJogador(jogador: UserDTO) {
        jogadores.insert(jogador, at: 0)
    }
    
    func getQuadra() -> QuadraDTO {
        return quadra
    }
    
    func getData() -> Date {
        return data
    }
    
    func setData(data: Date) {
        self.data = data
    }
    
    func getExportData() {
        var exportData : [String : Any] = ["quadra" : quadra.documentID,
                                           "data" : data]
        
        var jogadorData = [[String : Any]]()
        jogadores.forEach { (jogador) in
            jogadorData.append(["telefone" : jogador.telefone,
                                    "nome" : jogador.nome,
                         "statusPagamento" : false])
        }
        
        exportData.updateValue(jogadorData, forKey: "jogadores")
        
    }
    
}
