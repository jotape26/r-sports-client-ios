//
//  TimesController.swift
//  R Sports
//
//  Created by João Pedro Leite on 22/09/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

protocol TimesUpdateDelegate {
    func didUpdateTimes()
}

class TimesController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var timesTable: UITableView!
    @IBOutlet weak var btnCriarTime: UIButton!
    
//    fileprivate var btnCriarOnNav: UIBarButtonItem =
    
    var times = [TimeDTO]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnCriarTime.layer.cornerRadius = 5.0
        
        timesTable.register(UINib(nibName: "TimesCell", bundle: nil), forCellReuseIdentifier: "TimesCell")
        validateTimes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let btn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(clickTime))
        
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = btn
    }
    
    @IBAction func criarTimesClick(_ sender: Any) {
        performSegue(withIdentifier: "CreateTimeSegue", sender: nil)
    }
    
    fileprivate func validateTimes() {
        FirebaseService.getUserTimes { (userTimes) in
            self.view.stopLoading()
            self.times.removeAll()
            self.times = userTimes
            
            if self.times.isEmpty {
                self.alertView.isHidden = false
            } else {
                self.timesTable.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let contrl = segue.destination as? CriarTimeController {
            contrl.updateDelegate = self
        } else if let contrl = segue.destination as? TimeDetalhesController {
            contrl.selectedTime = times[timesTable.indexPathForSelectedRow?.row ?? 0]
        }
    }
    
    @objc func clickTime() {
        
        if let timesPend = SharedSession.shared.currentUser?.timesTemp, !timesPend.isEmpty {
            
            let alert = UIAlertController(title: "Adicionar Time", message: "Você possui convites para times em aberto. Você gostaria de ver os convites ou criar um novo time?", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Ver convites", style: .default, handler: { (act) in
                self.convitesTimesClick()
            }))
            alert.addAction(UIAlertAction(title: "Criar novo time", style: .default, handler: { (act) in
                self.criarTimesClick(self)
            }))
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            
            
        } else {
            criarTimesClick(self)
        }
    }
    
    func convitesTimesClick() {
        performSegue(withIdentifier: "ListaToConvitesSegue", sender: nil)
    }
    

}

extension TimesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimesCell") as! TimesCell
        cell.prepareForReuse()
        
        let currentTeam = times[indexPath.row]
        
        cell.lblNome.text = currentTeam.nome
        
        let nOfPlayers = currentTeam.jogadores?.filter({$0.pendente == false}).count ?? 0
        
        if nOfPlayers == 1 {
            cell.lblJogadores.text = "\(nOfPlayers) jogador."
        } else {
            cell.lblJogadores.text = "\(nOfPlayers) jogadores."
        }
        
        currentTeam.getImage { (image) in
            cell.imgTime.image = image
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ListaToTimeSegue", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TimesController: TimesUpdateDelegate {
    func didUpdateTimes() {
        validateTimes()
    }
}
