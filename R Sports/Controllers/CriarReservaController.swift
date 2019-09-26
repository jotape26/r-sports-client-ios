//
//  CriarReservaController.swift
//  R Sports
//
//  Created by João Leite on 09/06/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import NKVPhonePicker

class CriarReservaController: UIViewController {
    
    @IBOutlet weak var txtHorario: UITextField!
    @IBOutlet weak var lblQuadra: UILabel!
    @IBOutlet weak var lblEndereco: UILabel!
    @IBOutlet weak var lblValor: UILabel!
    @IBOutlet weak var lblValorPorPessoa: UILabel!
    
    var quadra : QuadraDTO!
    var time: TimeDTO?
    
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
        
        doneButton.tintColor = AppConstants.ColorConstants.defaultGreen
        
        var spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }()
    
    @objc func inputToolbarDonePressed() {
        if !datePicker.isSelected {
            datepicked(datePicker)
        }
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtHorario.delegate = self
        txtHorario.inputView = datePicker
        txtHorario.inputAccessoryView = inputToolbar
        
        lblQuadra.text = quadra?.nome
        lblEndereco.text = quadra?.endereco
        lblValor.text = quadra?.getTodayPrice()?.toCurrency()
        lblValorPorPessoa.text = quadra?.getTodayPrice()?.toCurrency()
    }
    
    func calcularValor(){
        if let time = time {
            if let preco = quadra?.getTodayPrice() {
                lblValorPorPessoa.text = (preco / Double(time.jogadores?.count ?? 1)).toCurrency()
            }
        }
    }
    
    @objc func datepicked(_ sender: UIDatePicker) {
//        guard let data = reserva.data else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let hourString = formatter.string(from: sender.date)
        
        formatter.dateFormat = "dd/MM/yyyy"
//        let dateString = formatter.string(from: data)
        
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
//        if let date = formatter.date(from: "\(dateString) \(hourString)") {
//            reserva.data = date
            txtHorario.text = hourString
            
//            print(formatter.string(from: data))
//        }
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
//            vc.reserva = reserva
        }
    }

    
}
