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
        guard let location = quadra.location else {
            performError()
            return
        }
        
        let manager = CLGeocoder()
        
        manager.reverseGeocodeLocation(location) { (placemarks, err) in
            if let placemark = placemarks?.first, let center = placemark.location?.coordinate {
                let annt = MKPlacemark(placemark: placemark)
                self.mapView.addAnnotation(annt)
                self.mapView.setCenter(center, animated: true)
                self.mapView.setRegion(MKCoordinateRegion(center: annt.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)), animated: true)
                
            } else {
                self.performError()
            }
        }
    }
    
    func performError(){
        self.navigationController?.popViewController(animated: true)
    }

}

extension MapController: MKMapViewDelegate {
    
}
