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
    
    lazy var inputToolbar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        var doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(inputToolbarDonePressed))
        
        doneButton.tintColor = SharedSession.shared.standardColor
        
        var spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }()
    
    @objc func inputToolbarDonePressed() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableJogadores.delegate = self
        tableJogadores.dataSource = self
        tableJogadores.register(UINib(nibName: "JogadoresCell", bundle: nil), forCellReuseIdentifier: "JogadoresCell")
        txtJogadoresCell.delegate = self
        txtHorario.inputView = datePicker
        txtHorario.inputAccessoryView = inputToolbar
        
        lblQuadra.text = reserva.quadra?.nome
        lblEndereco.text = reserva.quadra?.endereco
        lblValor.text = reserva.quadra?.preco?.toCurrency()
        lblValorPorPessoa.text = reserva.quadra?.preco?.toCurrency()
        
        FirebaseService.retrieveUserDatabaseRef(uid: FirebaseService.getCurrentUser()?.phoneNumber ?? "") { (currentUser) in
            DispatchQueue.main.async {
                self.reserva.addJogador(jogador: currentUser)
                self.calcularValor()
            }
        }
    }
    
    func calcularValor(){
        if !reserva.getJogadores().isEmpty {
            lblValorPorPessoa.text = ((reserva.quadra?.preco ?? 0.0) / Double(reserva.getJogadores().count)).toCurrency()
        }
        tableJogadores.reloadData()
    }
    
    @objc func datepicked(_ sender: UIDatePicker) {
        guard let data = reserva.data else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let hourString = formatter.string(from: sender.date)
        
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: data)
        
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        if let date = formatter.date(from: "\(dateString) \(hourString)") {
            reserva.data = date
            txtHorario.text = hourString
            
            print(formatter.string(from: data))
        }
    }

    @IBAction func btnAddClick(_ sender: Any) {
        txtJogadoresCell.resignFirstResponder()
        
        let numero = txtJogadoresCell.formatToPhone()
        if numero.count == 14 {
            
            if reserva.getJogadores().filter({ (user) -> Bool in
                if user.telefone == numero {
                    return true
                }
                return false
            }).isEmpty {
                let user = UserDTO()
                user.telefone = txtJogadoresCell.formatToPhone()
                self.reserva.addJogador(jogador: user)
                self.calcularValor()
                tableJogadores.reloadData()
            } else {
                txtJogadoresCell.textColor = .red
            }
            
        }
    }
    
    @IBAction func btnPagamentoClick(_ sender: Any) {
        if txtHorario.text == "" {
            txtHorario.setTextInvalid()
            return
        }
        
        performSegue(withIdentifier: "ReservaToPagamentoSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagamentoController {
            vc.reserva = reserva
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtJogadoresCell {
            if txtJogadoresCell.text?.isEmpty ?? false {
                txtJogadoresCell.text = "+55"
                txtJogadoresCell.textColor = .black
            }
        }
    }
    
}

extension CriarReservaController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reserva.getJogadores().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JogadoresCell") as! JogadoresCell
//        cell.configurarJogador(jogador: reserva.getJogadores()[indexPath.row])
        cell.phoneLabel.text = reserva.getJogadores()[indexPath.row].telefone

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // remove the item from the data model
            reserva.jogadores?.remove(at: indexPath.row)
            
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .left)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.calcularValor()
            }
            
        } else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
        }
    }
}
