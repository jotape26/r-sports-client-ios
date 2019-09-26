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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "group-icon"), style: .plain, target: self, action: #selector(clickTime))
        validateTimes()
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
        }
    }
    
    @objc func clickTime() {
        criarTimesClick(self)
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
        
        
        cell.getTimeImage(docID: currentTeam.timeID ?? "")

        return cell
    }
}

extension TimesController: TimesUpdateDelegate {
    func didUpdateTimes() {
        validateTimes()
    }
}
