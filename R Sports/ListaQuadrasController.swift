//
//  ListaQuadrasController.swift
//  R Sports
//
//  Created by João Pedro Leite on 29/03/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class ListaQuadrasController: UIViewController {

    @IBOutlet weak var quadrasTable: UITableView!
    
    var quadras = [QuadraDTO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quadrasTable.register(UINib(nibName: "QuadrasCell", bundle: nil), forCellReuseIdentifier: "QuadrasCell")
        // Do any additional setup after loading the view.
        FirebaseService.retrieveCourts { (qDTO) in
            self.quadras = qDTO
            self.quadrasTable.reloadData()
        }
    }

}

extension ListaQuadrasController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quadras.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let current = quadras[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuadrasCell") as! QuadrasCell
        
        cell.lbNomeQuadra.text = current.nome
        cell.lbEnderecoQuadra.text = current.endereco
        cell.lbPrecoQuadra.text = "\(current.preco ?? 0.0)"
        cell.ratingQuadra.rating = Double(current.rating ?? 0)
        
        cell.downloadImage(path: current.imagePath)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    
}

