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
    
    var loggedUserPaidStatus: Bool = false
    
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
    
    func finishLoading(){
        self.view.stopLoading()
        
        showInfo = true
        
        lbReservaLabel.text = "Reserva #\(String(reserva.docID?.prefix(6) ?? "").uppercased())"
        lbReservaStatus.text = reserva.status
        lbTotalPago.text = reserva.valorPago?.toCurrency()
        lbTotalPessoa.text = reserva.jogadores?.first?.valorAPagar?.toCurrency()
        
        reserva.jogadores?.forEach({ (jogador) in
            if jogador.user?.documentID == FirebaseService.getCurrentUser()?.phoneNumber {
                loggedUserPaidStatus = jogador.statusPagamento ?? false
            }
        })
        updateButton()
        
        btnEndereco.setTitle(reserva.quadra?.endereco, for: .normal)
        btnTelefone.setTitle(reserva.quadra?.telefone, for: .normal)
        jogadoresCollection.reloadData()
    }
    
    func updateButton(){
        if loggedUserPaidStatus {
            btnNotificar.setTitle("Notificar Jogadores", for: .normal)
            btnNotificar.addTarget(self, action: #selector(btnNotificarClick(_:)), for: .touchUpInside)
        } else {
            btnNotificar.setTitle("Realizar Pagamento", for: .normal)
            btnNotificar.addTarget(self, action: #selector(btnPagarClick(_:)), for: .touchUpInside)
        }
    }
    
    @objc func btnPagarClick(_ sender: Any) {
        performSegue(withIdentifier: "DetalheReservaToPagamentoSegue", sender: nil)
    }
    
    @objc func btnNotificarClick(_ sender: Any) {
        self.view.startLoading()
        guard let docID = reserva.docID else {
            self.view.stopLoading()
            return
        }
        
        RSportsService.notifyUsers(reservaID: docID) {
            self.view.stopLoading()
            AlertsHelper.showMessage(message: "Jogadores notificados!")
        }
    }
    
    @IBAction func btnEnderecoClick(_ sender: Any) {
        performSegue(withIdentifier: "ReservaToMapSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MapController {
            vc.quadra = reserva.quadra
        } else if let vc = segue.destination as? PagamentoController {
            vc.reservaLista = reserva
        }
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
