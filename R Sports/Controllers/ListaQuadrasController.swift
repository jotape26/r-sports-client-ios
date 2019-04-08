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
    private let locationManager = CLLocationManager()
    var currentLocation : CLLocation? {
        didSet {
            self.quadrasTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        quadrasTable.register(UINib(nibName: "QuadrasCell", bundle: nil), forCellReuseIdentifier: "QuadrasCell")
        // Do any additional setup after loading the view.
        FirebaseService.retrieveCourts { (qDTO) in
            self.quadras = qDTO
            self.getLocation(after: {
                self.currentLocation = self.locationManager.location
            })
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
        cell.lbPrecoQuadra.text = "\(current.preco ?? 0.0)"
        cell.ratingQuadra.rating = Double(current.rating ?? 0)
        
        cell.downloadImage(path: current.imagePath)
        
        if let distance = current.distance {
            cell.lbDistancia.text = "\(distance.rounded())m"
        } else {
            cell.lbDistancia.text = nil
        }
        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
}

extension ListaQuadrasController: CLLocationManagerDelegate {
    
    func getLocation(after: @escaping ()->()){
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            return
        }
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        after()
    }
}
