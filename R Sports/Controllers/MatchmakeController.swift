//
//  MatchmakeController.swift
//  R Sports
//
//  Created by João Pedro Leite on 16/09/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class MatchmakeController: UIViewController {
    
    var eventos = [QuadraDTO]()
    
    @IBOutlet weak var eventosTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        eventosTable.register(UINib(nibName: "EventosCell", bundle: nil), forCellReuseIdentifier: "EventosCell")
    }
}

// MARK:- TableView Methods
extension MatchmakeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventosCell") as! EventosCell
        return cell
    }
    
    
}
