//
//  AppConstants.swift
//  R Sports
//
//  Created by João Pedro Leite on 22/07/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

struct AppConstants {
    
    static let ArrayServicosDefault = [ServicoQuadra(type: .kBAR, description: "Essa quadra conta com um bar para realizar confraternizações antes e depois das partidas."),
    ServicoQuadra(type: .kARBITRO, description: "Essa quadra conta com um arbitro para apitar as partidas."),
    ServicoQuadra(type: .kCHURRASQUEIRA, description: "Essa quadra possui uma churrasqueira para realização de confraternizações já inclusa no preço da reserva (Carnes não estão incluidas no serviço de churrasqueira)."),
    ServicoQuadra(type: .kVESTIARIO, description: "Essa quadra conta com um vestiário para troca de roupa e higienização depois das partidas."),
    ServicoQuadra(type: .kESTACIONAMENTO, description: "Essa quadra conta com um estacionamento para os jogadores, com vagas exclusivas para microonibus")]
    
    struct ColorConstants {
        static let defaultGreen = #colorLiteral(red: 0.07843137255, green: 0.462745098, blue: 0.3333333333, alpha: 1)
        static let highlightGreen = #colorLiteral(red: 0.5450980392, green: 0.7843137255, blue: 0.4274509804, alpha: 1)
        static let errorRed = #colorLiteral(red: 0.7333333333, green: 0, blue: 0, alpha: 1)
    }
}
