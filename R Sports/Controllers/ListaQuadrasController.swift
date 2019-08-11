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
    
    private var quadras = [QuadraDTO]()
    private var timer : Timer?
    private var error = 0
    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = AppConstants.ColorConstants.defaultGreen
        refresh.attributedTitle = NSAttributedString(string: "Procurando quadras perto de você", attributes: [.foregroundColor : AppConstants.ColorConstants.defaultGreen])
        return refresh
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quadrasTable.register(UINib(nibName: "QuadrasCell", bundle: nil), forCellReuseIdentifier: "QuadrasCell")
        quadrasTable.register(UINib(nibName: "NoQuadrasCell", bundle: nil), forCellReuseIdentifier: "NoQuadrasCell")
        refreshControl.addTarget(self, action: #selector(startPooling), for: .valueChanged)
        quadrasTable.refreshControl = refreshControl
        // Do any additional setup after loading the view.
        
        refreshControl.beginRefreshing()
        startPooling()
        
    }
    
    @objc func startPooling() {
        error = 0
        self.quadrasTable.reloadData()
        if let location = SharedSession.shared.currentLocation {
            
            timer = Timer.scheduledTimer(timeInterval: 10,
                                         target: self,
                                         selector: #selector(stopPooling),
                                         userInfo: nil, repeats: true)
            
            FirebaseService.retrieveCourts(userLocation: location) { (qDTO) in
                self.refreshControl.endRefreshing()
                self.timer?.invalidate()
                self.timer = nil
                
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
    
    @objc func stopPooling() {
        self.refreshControl.endRefreshing()
        FirebaseService.stopCourtQuery()
        error = 1
        self.quadrasTable.reloadData()
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
        if error == 1 {
            return 1
        } else {
            return quadras.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if error == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "NoQuadrasCell")!
        } else {
            let current = quadras[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuadrasCell") as! QuadrasCell
            cell.prepareForReuse()
            
            cell.lbNomeQuadra.text = current.nome
            cell.lbEnderecoQuadra.text = current.endereco
            
            cell.lbPrecoQuadra.text = current.preco?.toCurrency()
            
            cell.ratingQuadra.rating = Double(current.rating ?? 0)
            
            if var path = current.imagens?.first, let docID = current.documentID {
                path = "imagensQuadras/\(docID)/\(path)"
                cell.downloadImage(path: path)
            }
            
            let distanceMeasure = Measurement(value: current.distance.rounded(toPlaces: 2), unit: UnitLength.meters)
            cell.lbDistancia.text = MeasurementFormatter().string(for: distanceMeasure)

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ListaToDetailsSegue", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
