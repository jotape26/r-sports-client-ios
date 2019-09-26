//
//  TimeDetalhesController.swift
//  R Sports
//
//  Created by João Pedro Leite on 26/09/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class TimeDetalhesController: UIViewController {

    @IBOutlet weak var imgTime: UIImageView!
    @IBOutlet weak var lblNomeTime: UILabel!
    @IBOutlet weak var lblPartidas: UILabel!
    @IBOutlet weak var lblJogadores: UILabel!
    
    @IBOutlet weak var segmentTipoEstatistica: UISegmentedControl!
    @IBOutlet weak var tbDetalhes: UITableView!
    
    var selectedTime: TimeDTO!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tbDetalhes.register(UINib(nibName: "JogadorTimeCell", bundle: nil), forCellReuseIdentifier: "JogadorTimeCell")
        
        lblNomeTime.text = selectedTime.nome
        lblJogadores.text = selectedTime.getJogadoresConfirmed()
        lblPartidas.text = "\(selectedTime.partidas?.count ?? 0) Partidas"
        
        if selectedTime.isDownloadingImage {
            selectedTime.observers.append(self)
        } else {
            self.imgTime.image = selectedTime.timeImage
            self.imgTime.setRounded()
            self.imgTime.layer.borderWidth = 5.0
            self.imgTime.layer.borderColor = AppConstants.ColorConstants.highlightGreen.cgColor
        }
    }
    @IBAction func segmentChanged(_ sender: Any) {
        DispatchQueue.main.async {
            self.tbDetalhes.reloadData()
        }
    }
}

extension TimeDetalhesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentTipoEstatistica.selectedSegmentIndex == 0 {
            return 0
        } else {
            return selectedTime.jogadores?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JogadorTimeCell") as! JogadorTimeCell
        cell.prepareForReuse()
        
        let jogador = selectedTime.jogadores?[indexPath.row]
        
        if jogador?.pendente ?? true {
            cell.txtNome.text = jogador?.telefone
            cell.playerStillPending()
        } else {
            cell.txtNome.text = jogador?.nome
            cell.txtPartidas.text = (jogador?.partidasNoTime ?? 0).description
            
            cell.txtGols.text = (jogador?.golsNoTime ?? 0).description
            
            cell.txtAssistencias.text = (jogador?.assistsNoTime ?? 0).description
        }
        
        return cell
    }
}

extension TimeDetalhesController: ImageObserver {
    func didFinishDownloading() {
        self.imgTime.image = selectedTime.timeImage
        self.imgTime.setRounded()
        self.imgTime.layer.borderWidth = 5.0
        self.imgTime.layer.borderColor = AppConstants.ColorConstants.highlightGreen.cgColor
    }
}
