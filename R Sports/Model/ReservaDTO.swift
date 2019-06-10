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
}
