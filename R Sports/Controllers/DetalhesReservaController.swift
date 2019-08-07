//
//  DetalhesReservaController.swift
//  R Sports
//
//  Created by João Pedro Leite on 07/08/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import CollectionViewGridLayout

class DetalhesReservaController: UIViewController {
    
    var reserva : ReservaListaDTO!
    var showInfo = false
    
    @IBOutlet weak var lbReservaLabel: UILabel!
    @IBOutlet weak var lbReservaStatus: UILabel!
    @IBOutlet weak var lbTotalPessoa: UILabel!
    @IBOutlet weak var lbTotalPago: UILabel!
    
    @IBOutlet weak var btnNotificar: UIButton!
    @IBOutlet weak var btnEndereco: UIButton!
    @IBOutlet weak var btnTelefone: UIButton!
    
    @IBOutlet weak var jogadoresCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = reserva.nomeQuadra
        let layout = CollectionViewVerticalGridLayout()
        jogadoresCollection.collectionViewLayout = layout
        
        self.btnNotificar.layer.cornerRadius = 5.0
        
        self.view.startLoading()
        
        FirebaseService.getQuadraById(quadraID: reserva.quadraID ?? "") { (quadra) in
            self.reserva.quadra = quadra
            self.finishLoading()
        }
    }
    
    @IBAction func btnNotificarClick(_ sender: Any) {
    }
    
    func finishLoading(){
        self.view.stopLoading()
        
        showInfo = true
        
        lbReservaLabel.text = "Reserva #\(String(reserva.docID?.prefix(6) ?? "").uppercased())"
        lbReservaStatus.text = reserva.status
        lbTotalPago.text = reserva.valorPago?.toCurrency()
        lbTotalPessoa.text = reserva.jogadores?.first?.valorAPagar?.toCurrency()
        
        btnEndereco.setTitle(reserva.quadra?.endereco, for: .normal)
        btnTelefone.setTitle(reserva.quadra?.telefone, for: .normal)
        jogadoresCollection.reloadData()
    }
}

extension DetalhesReservaController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if showInfo {
            return reserva.jogadores?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JogadoresStatusCell", for: indexPath) as! JogadoresStatusCell
        cell.prepareForReuse()
        
        let t = reserva.jogadores![indexPath.row]
        
        cell.lbNome.text = t.userName?.components(separatedBy: " ").first
        
        if t.statusPagamento ?? false {
            cell.imgStatus.image = UIImage(named: "green-check-filled")
        } else {
            cell.imgStatus.image = UIImage(named: "grey-circle")
        }
        return cell
    }
}

extension DetalhesReservaController: CollectionViewDelegateVerticalGridLayout {
    @objc func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       numberOfColumnsForSection section: Int) -> Int {
        return 3
    }
}
