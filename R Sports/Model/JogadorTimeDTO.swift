//
//  JogadorTimeDTO.swift
//  R Sports
//
//  Created by João Pedro Leite on 22/09/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import ObjectMapper

class EstatisticaDTO {
    var jogador: JogadorTimeDTO?
    var gols: Int?
    var assistencias: Int?
}

class PartidaDTO: ImmutableMappable {
    required init(map: Map) throws {
        reserva = try? map.value("reserva")
        dataHora = try? map.value("data")
        quadraID = try? map.value("quadra")
        
        if let quadraID = quadraID {
            FirebaseService.getCourt(quadra: quadraID) { (quad) in
                self.quadraObj = quad
            }
        }
    }
    
    var reserva: DocumentReference?
    var quadraID: String?
    var quadraObj: QuadraDTO?
    var dataHora: Date?

}

protocol ImageObserver {
    func didFinishDownloading()
}

class TimeDTO: ImmutableMappable {
    
    init(){}
    
    required init(map: Map) throws {
        nome = try? map.value("nome")
        jogadores = try? map.value("jogadores")
        partidas = try? map.value("partidas")
        
        jogadores?.sort(by: { (jog1, jog2) -> Bool in
            if jog1.pendente == false || jog2.pendente == true {
                return true
            }
            return false
        })
        
        criadorName = try? map.value("criadorName")
    }
    
    var nome: String?
    var jogadores: [JogadorTimeDTO]?
    var partidas: [PartidaDTO]?
    var timeID : String?
    var timeImage: UIImage? {
        didSet {
            observers.forEach { (observer) in
                observer.didFinishDownloading()
            }
        }
    }
    
    var isDownloadingImage = false
    var observers = [ImageObserver]()
    
    var criadorName: String?
    
    func getCreationData() -> [String: Any] {
        
        var params : [String: Any] =  ["nome" : self.nome ?? "",
        "partidas": []]
        
        var jogadoresArr = [[String:Any]]()
        
        for (index, jogador) in (jogadores ?? []).enumerated() {
            var jog : [String : Any] = [:]
            
            if index == 0 {
                guard let phone = jogador.telefone, let nome = jogador.nome else { return [:] }
                jog.updateValue(phone, forKey: "telefone")
                jog.updateValue(nome, forKey: "nome")
                jog.updateValue(false, forKey: "pendente")
                jog.updateValue(0, forKey: "golsNoTime")
                jog.updateValue(0, forKey: "assistsNoTime")
                
                params.updateValue(nome, forKey: "criadorName")
                params.updateValue(phone, forKey: "criadorNumber")
                
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
        
        params.updateValue(jogadoresArr, forKey: "jogadores")
        
        return params
    }
    
    
    func getImage(saveCallback: @escaping(UIImage)->()) {
        self.isDownloadingImage = true
        FirebaseService.getTimeImage(docID: timeID ?? "", success: { (image) in
            self.isDownloadingImage = false
            self.timeImage = image
            saveCallback(image)
        }) {}
    }
    
    func getJogadoresConfirmed() -> String {
        let jog = self.jogadores?.filter({$0.pendente == false}).count ?? 1
        
        if jog == 1 {
            return "1 Jogador"
        } else {
            return "\(jog) Jogadores"
        }
    }
    
    func getJogadoresConfirmedNumber() -> Int {
        return self.jogadores?.filter({$0.pendente == false}).count ?? 1
    }
}

class JogadorTimeDTO: ImmutableMappable {
    var nome: String?
    var telefone : String?
    var pendente: Bool = true
    var docRef : String?
    var golsNoTime: Int?
    var assistsNoTime: Int?
    var partidasNoTime: Int?
    
    init() {}
    
    required init(map: Map) throws {
        nome = try? map.value("nome")
        telefone = try? map.value("telefone")
        pendente = (try? map.value("pendente")) ?? true
        docRef = try map.value("documentID")
        golsNoTime = try? map.value("golsNoTime")
        assistsNoTime = try? map.value("assistsNoTime")
        partidasNoTime = try? map.value("partidasNoTime")
    }
}
