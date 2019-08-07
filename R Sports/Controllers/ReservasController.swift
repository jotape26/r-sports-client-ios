//
//  ReservasController.swift
//  R Sports
//
//  Created by João Leite on 28/05/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

enum ReservasFiltrosOptions: Int {
    case kTodos
    case kPendentes
    case kPagos
}

class ReservasController: UIViewController {

    var reservas = [ReservaListaDTO]()
    var filteredReservas = [ReservaListaDTO]()
    
    @IBOutlet weak var reservasTable: UITableView!
    @IBOutlet weak var segmentStatus: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        reservasTable.register(UINib(nibName: "ReservasCell", bundle: nil), forCellReuseIdentifier: "ReservasCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FirebaseService.getUserReservations { (reservas) in
            self.reservas = reservas
            self.applyFilter()
        }
    }
    
    func applyFilter() {
        self.filteredReservas.removeAll()
        
        if segmentStatus.selectedSegmentIndex == ReservasFiltrosOptions.kTodos.rawValue {
            self.filteredReservas = reservas
        } else if segmentStatus.selectedSegmentIndex == ReservasFiltrosOptions.kPendentes.rawValue {
            reservas.forEach { (reserva) in
                if reserva.status == "Pendente" {
                    filteredReservas.append(reserva)
                }
            }
        } else if segmentStatus.selectedSegmentIndex == ReservasFiltrosOptions.kPagos.rawValue {
            reservas.forEach { (reserva) in
                if reserva.status == "Pago" {
                    filteredReservas.append(reserva)
                }
            }
        }
        
        self.reservasTable.reloadData()
    }
    
    @IBAction func segmentDidChange(_ sender: Any) {
        applyFilter()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cont = segue.destination as? DetalhesReservaController {
            guard let iPath = reservasTable.indexPathForSelectedRow else { return }
            cont.reserva = reservas[iPath.row]
        }
    }
    
}

extension ReservasController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredReservas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReservasCell", for: indexPath) as! ReservasCell
        
        let currentReserva = filteredReservas[indexPath.row]
        
        cell.lbQuadra.text = currentReserva.nomeQuadra
        cell.lbData.text = currentReserva.dataHora?.formatToDefault()
        cell.lbStatus.text = currentReserva.status
        cell.lbValor.text = currentReserva.valorPago?.toCurrency()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ListaToReservaDetailSegue", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
