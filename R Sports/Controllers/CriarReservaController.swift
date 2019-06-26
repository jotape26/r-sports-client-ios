//
//  CriarReservaController.swift
//  R Sports
//
//  Created by João Leite on 09/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class CriarReservaController: UIViewController {
    
    @IBOutlet weak var tableJogadores: UITableView!
    @IBOutlet weak var txtJogadoresCell: SwiftMaskTextfield!
    @IBOutlet weak var txtHorario: UITextField!
    @IBOutlet weak var lblQuadra: UILabel!
    @IBOutlet weak var lblEndereco: UILabel!
    @IBOutlet weak var lblValor: UILabel!
    @IBOutlet weak var lblValorPorPessoa: UILabel!
    
    var reserva : ReservaDTO!
    
    var datePicker: UIDatePicker = {
        let uipick = UIDatePicker()
        uipick.datePickerMode = .time
        uipick.minuteInterval = 30
        uipick.addTarget(self, action: #selector(datepicked(_:)), for: .valueChanged)
        return uipick
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableJogadores.delegate = self
        tableJogadores.dataSource = self
        tableJogadores.register(UINib(nibName: "JogadoresCell", bundle: nil), forCellReuseIdentifier: "JogadoresCell")
        txtJogadoresCell.delegate = self
        txtHorario.inputView = datePicker
        
        lblQuadra.text = reserva.quadra.nome
        lblEndereco.text = reserva.quadra.endereco
        lblValor.text = reserva.quadra.preco?.toCurrency()
        lblValorPorPessoa.text = reserva.quadra.preco?.toCurrency()
        
        FirebaseService.retrieveUserDatabaseRef(uid: FirebaseService.getCurrentUser()?.phoneNumber ?? "") { (currentUser) in
            self.reserva.addJogador(jogador: currentUser)
            self.calcularValor()
            self.tableJogadores.reloadData()
        }
    }
    
    func calcularValor(){
        lblValorPorPessoa.text = ((reserva.quadra.preco ?? 0.0) / Double(reserva.getJogadores().count)).toCurrency()
    }
    
    @objc func datepicked(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        txtHorario.text = formatter.string(from: sender.date)
        txtHorario.resignFirstResponder()
    }

    @IBAction func btnAddClick(_ sender: Any) {
        txtJogadoresCell.resignFirstResponder()
        
        let numero = txtJogadoresCell.formatToPhone()
        if numero.count == 14 {
            if numero != FirebaseService.getCurrentUser()?.phoneNumber {
                let user = UserDTO()
                user.telefone = txtJogadoresCell.formatToPhone()
                self.reserva.addJogador(jogador: user)
                self.calcularValor()
                tableJogadores.reloadData()
            }
        } else {
            txtJogadoresCell.textColor = .red
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtJogadoresCell.text = nil
        txtJogadoresCell.textColor = .black
    }
    
}

extension CriarReservaController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reserva.getJogadores().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JogadoresCell") as! JogadoresCell
        cell.configurarJogador(jogador: reserva.getJogadores()[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
