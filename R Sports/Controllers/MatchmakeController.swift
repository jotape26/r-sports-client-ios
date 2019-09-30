//
//  MatchmakeController.swift
//  R Sports
//
//  Created by João Pedro Leite on 16/09/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import ObjectMapper
import FirebaseFirestore

class EventoDTO: ImmutableMappable {
    var data : Date?
    var imgCapa : String?
    var preco : Double?
    var quadra : DocumentReference?
    var quadraDTO:  QuadraDTO?
    var titulo : String?
    var jogadores: [String]?
    var vagas : Int?
    var documentID: String?
    
    required init(map: Map) throws {
        data = try? map.value("data")
        imgCapa = try? map.value("imgCapa")
        preco = try? map.value("preco")
        quadra = try? map.value("quadra")
        titulo = try? map.value("titulo")
        jogadores = try? map.value("jogadores")
        vagas = try? map.value("vagas")
    }
}

class MatchmakeController: UIViewController {
    
    var eventos = [EventoDTO]()
    
    @IBOutlet weak var eventosTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        eventosTable.register(UINib(nibName: "EventosCell", bundle: nil), forCellReuseIdentifier: "EventosCell")
        FirebaseService.getEventos { (eventz) in
            self.eventos = eventz
            DispatchQueue.main.async {
                self.eventosTable.reloadData()
            }
        }
    }
}

// MARK:- TableView Methods
extension MatchmakeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventosCell") as! EventosCell
        
        let event = eventos[indexPath.row]
        
        cell.lblNomeEvento.text = event.titulo
        cell.lblPreco.text = event.preco?.toCurrency()
        cell.lblData.text = event.data?.formatToDefault()
        cell.lblPosicao.text = "Faltam \((event.vagas ?? 0) - (event.jogadores?.count ?? 0)) vagas."
        
        FirebaseService.getEventoImage(docID: event.documentID ?? "", success: { (img) in
            cell.imgEvento.image = img
        }) {
            cell.imgEvento.image = nil
        }
        
        FirebaseService.getCourt(quadra: event.quadra?.documentID ?? "") { (qDTO) in
            let t = "imagensQuadras/\(qDTO.documentID!)/\(qDTO.imagens!.first!)"
            FirebaseService.getCourtImage(path: t, success: { (img) in
                cell.imgQuadra.image = img
            }) {
                cell.imgEvento.image = nil
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
