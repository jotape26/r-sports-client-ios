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
        tbDetalhes.register(UINib(nibName: "PartidaCell", bundle: nil), forCellReuseIdentifier: "PartidaCell")
        
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
            return selectedTime.partidas?.count ?? 0
        } else {
            return selectedTime.jogadores?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if segmentTipoEstatistica.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PartidaCell") as! PartidaCell
            cell.prepareForReuse()
            
            let partidas = selectedTime.partidas?[indexPath.row]
            
            cell.txtNomeQuadra.text = partidas?.quadraObj?.nome
            cell.txtDataPartida.text = partidas?.dataHora?.formatToDefault()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JogadorTimeCell") as! JogadorTimeCell
            cell.prepareForReuse()
            
            let jogador = selectedTime.jogadores?[indexPath.row]
            
            if indexPath.row == 0 {
                cell.imgTrophy.image = UIImage(named: "trophy-icon-white")
            } else {
                cell.imgTrophy.isHidden = true
            }
            
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if segmentTipoEstatistica.selectedSegmentIndex == 0 {
            
        } else {
            
            let player = selectedTime.jogadores?[indexPath.row]
            
            if isUserTeamAdmin() {
                let alert = UIAlertController(title: "Alterar estatisticas", message: "Digite o numero de gols e assistencias para o jogador: \(player?.nome ?? "")", preferredStyle: .alert)
                
                alert.addTextField { (customTextField) in
                    customTextField.placeholder = "Gols"
                }
                
                alert.addTextField { (customTextField) in
                    customTextField.placeholder = "Assistencias"
                }
                
                alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { (act) in
                    //TODO HANDLE
                }))
                
                alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func isUserTeamAdmin() -> Bool {
        return true
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
