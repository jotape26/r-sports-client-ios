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
    var mkMark : MKMapItem?
    
    var quadra: QuadraDTO!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.showsUserLocation = true
        self.title = quadra.nome
        createQuadraPin()
    }
    
    @IBAction func rotaBtnClick(_ sender: Any) {
        mkMark?.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    func createQuadraPin(){
        guard let location = quadra.location else {
            performError()
            return
        }
        
        let manager = CLGeocoder()
        
        self.view.startLoading()
        manager.reverseGeocodeLocation(location) { (placemarks, err) in
            self.view.stopLoading()
            if let placemark = placemarks?.first, let center = placemark.location?.coordinate {
                let annt = MKPlacemark(placemark: placemark)
                
                
                
                self.mkMark = MKMapItem(placemark: MKPlacemark(placemark: placemark))

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
