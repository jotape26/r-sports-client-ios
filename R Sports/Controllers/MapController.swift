//
//  MapController.swift
//  R Sports
//
//  Created by João Pedro Leite on 07/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var quadra: QuadraDTO!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        mapView.showsUserLocation = true
        self.title = quadra.nome
        createQuadraPin()
    }
    
    func createQuadraPin(){
        let manager = CLGeocoder()
        manager.geocodeAddressString(quadra.endereco ?? "") { (placemarks, err) in
            
            let annt = MKPlacemark(placemark: placemarks!.first!)
            self.mapView.addAnnotation(annt)
            
            self.mapView.setCenter(placemarks!.first!.location!.coordinate, animated: true)
            
            self.mapView.setRegion(MKCoordinateRegion(center: annt.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)), animated: true)
        }
    }

}

extension MapController: MKMapViewDelegate {
    
}
