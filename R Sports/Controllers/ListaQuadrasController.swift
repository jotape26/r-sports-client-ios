//
//  ListaQuadrasController.swift
//  R Sports
//
//  Created by João Pedro Leite on 29/03/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import CoreLocation

class ListaQuadrasController: UIViewController{
    
    @IBOutlet weak var quadrasTable: UITableView!
    
    var quadras = [QuadraDTO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quadrasTable.register(UINib(nibName: "QuadrasCell", bundle: nil), forCellReuseIdentifier: "QuadrasCell")
        // Do any additional setup after loading the view.
        
        self.view.startLoading()
        if let location = SharedSession.shared.currentLocation {
            FirebaseService.retrieveCourts(userLocation: location) { (qDTO) in
                self.view.stopLoading()
                if !self.quadras.contains(where: { (dto) -> Bool in
                    if qDTO.documentID == dto.documentID {
                        return true
                    }
                    return false
                }) {
                    self.quadras.sort(by: { $0.distance(to: location) < $1.distance(to: location) })
                    self.quadras.append(qDTO)
                    self.quadrasTable.reloadData()
                }
               
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? QuadraDetailController {
            
            guard let iPath = quadrasTable.indexPathForSelectedRow else { return }
            
            vc.selectedQuadra = quadras[iPath.row]
        }
    }
}

extension ListaQuadrasController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quadras.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let current = quadras[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuadrasCell") as! QuadrasCell
        
        cell.lbNomeQuadra.text = current.nome
        cell.lbEnderecoQuadra.text = current.endereco

        cell.lbPrecoQuadra.text = current.preco?.toCurrency()
        
        cell.ratingQuadra.rating = Double(current.rating ?? 0)
        
        if var path = current.imagens?.first, let docID = current.documentID {
            path = "imagensQuadras/\(docID)/\(path)"
            cell.downloadImage(path: path)
        }
        
        if let distance = current.distance {
            let distanceMeasure = Measurement(value: distance, unit: UnitLength.kilometers)
            cell.lbDistancia.text = MeasurementFormatter().string(from: distanceMeasure)
        } else {
            cell.lbDistancia.text = nil
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ListaToDetailsSegue", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
