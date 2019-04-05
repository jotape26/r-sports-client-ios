//
//  QuadraDTO.swift
//  R Sports
//
//  Created by João Pedro Leite on 29/03/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation

class QuadraDTO {
    var nome: String!
    var endereco: String!
    var rating: Double!
    var preco: Double!
    
    init(nome: String, endereco: String, rating: Double, preco: Double) {
        self.nome = nome
        self.endereco = endereco
        self.rating = rating
        self.preco = preco
    }
}
