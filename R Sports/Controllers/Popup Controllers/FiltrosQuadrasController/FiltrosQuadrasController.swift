//
//  FiltrosQuadrasController.swift
//  R Sports
//
//  Created by João Pedro Leite on 11/08/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import Cosmos

class QuadrasFiltrosViewModel {
    var distancia : Int {
        get {
            return UserDefaults.standard.integer(forKey: "quadraLastUsedDistance")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "quadraLastUsedDistance")
        }
    }
    
    var rating : Int {
        get {
            return UserDefaults.standard.integer(forKey: "quadraLastUsedRating")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "quadraLastUsedRating")
        }
    }
}

protocol FiltrosQuadrasDelegate {
    func filtrosDidChange()
}

class FiltrosQuadrasController: UIViewController {
    
    @IBOutlet weak var sliderDistancia: UISlider!
    @IBOutlet weak var lbDistancia: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    var viewModel : QuadrasFiltrosViewModel!
    var caller : FiltrosQuadrasDelegate!
    var needsReload = false
    
    class func create(vm : QuadrasFiltrosViewModel, caller : FiltrosQuadrasDelegate) -> FiltrosQuadrasController {
        let cont = FiltrosQuadrasController(nibName: "FiltrosQuadrasController", bundle: nil)
        cont.viewModel = vm
        cont.caller = caller
        return cont
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sliderDistancia.setThumbImage(UIImage(named: "bola-icon")!, for: .normal)
        sliderDistancia.value = Float(viewModel.distancia)
        slideDidChange(sliderDistancia as Any)
        
        ratingView.rating = Double(viewModel.rating)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.distancia = Int(sliderDistancia.value)
        viewModel.rating = Int(ratingView.rating)
        caller.filtrosDidChange()
    }
    

    @IBAction func slideDidChange(_ sender: Any) {
        
        guard let sender = sender as? UISlider else { return }
        let value = Int(sender.value)
        let distanceMeasure = Measurement(value: Double(value), unit: UnitLength.kilometers)
        lbDistancia.text = MeasurementFormatter().string(for: distanceMeasure)
    }
    
}
