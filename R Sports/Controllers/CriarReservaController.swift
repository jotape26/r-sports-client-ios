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
    
    @IBOutlet weak var lblNomeQuadra: UILabel!
    @IBOutlet weak var lblEndereçoQuadra: UILabel!
    @IBOutlet weak var txtHorario: UITextField!
    @IBOutlet weak var stepperDuracao: UISegmentedControl!
    @IBOutlet weak var imgTime: UIImageView!
    @IBOutlet weak var lblNomeTime: UILabel!
    @IBOutlet weak var lblJogadoresTime: UILabel!
    @IBOutlet weak var lblSubtotal: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblDisclaimer: UILabel!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var viewTimeHeight: NSLayoutConstraint!
    @IBOutlet weak var btnPagamento: UIButton!
    
    
    var quadra : QuadraDTO!
    var time: TimeDTO?
    var data: Date?
    
    var newReserva: CriacaoReservaDTO!
    
    var datePicker: UIDatePicker = {
        let uipick = UIDatePicker()
        uipick.datePickerMode = .dateAndTime
        uipick.minimumDate = Date()
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
        
        lblNomeQuadra.text = quadra?.nome
        lblEndereçoQuadra.text = quadra?.endereco
        lblSubtotal.text = quadra?.getTodayPrice()?.toCurrency()
        
        
        imgTime.setRounded()
        
        btnPagamento.layer.cornerRadius = 5.0
        
        if let time = time {
            self.view.startLoading()
            FirebaseService.getTimeImage(docID: time.timeID ?? "", success: { (image) in
                self.view.stopLoading()
                
                self.lblNomeTime.text = time.nome
                self.lblJogadoresTime.text = time.getJogadoresConfirmed()
                self.imgTime.image = image
                
                self.imgTime.layer.borderWidth = 5.0
                self.imgTime.layer.borderColor = AppConstants.ColorConstants.highlightGreen.cgColor
                
                self.calcularValor()
                
                self.lblDisclaimer.text = "O valor da reserva foi dividido pelo número de jogadores confirmados no time selecionado."
            }) {
                self.viewTimeHeight.constant = 0
                self.imgTime.isHidden = true
            }
            
        } else {
            viewTime.isHidden = true
            self.calcularValor()
        }
    }
    
    func calcularValor(){
        guard let preco = quadra.getTodayPrice() else { return }
        if let time = time {
            lblTotal.text = (preco / Double(time.getJogadoresConfirmedNumber())).toCurrency()
        } else {
            lblTotal.text = preco.toCurrency()
        }
    }
    
    @objc func datepicked(_ sender: UIDatePicker) {
        
        self.data = sender.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        self.txtHorario.text = formatter.string(from: sender.date)
    }
    
    @IBAction func btnPagamentoClick(_ sender: Any) {
        if data == nil {
            txtHorario.setTextInvalid()
            return
        }
        
        if stepperDuracao.selectedSegmentIndex == -1 {
            AlertsHelper.showErrorMessage(message: "Por favor selecione uma duração")
            return
        }
        
        let newRes = CriacaoReservaDTO(quadra: quadra, data: data!, duracao: stepperDuracao.selectedSegmentIndex + 1)
        
        if let selTime = time {
            newRes.time = selTime
        }
        
        self.newReserva = newRes
        
        performSegue(withIdentifier: "ReservaToPagamentoSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagamentoController {
            vc.reserva = self.newReserva
        }
    }

    
}
