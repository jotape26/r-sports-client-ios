//
//  QuadraServicosController.swift
//  R Sports
//
//  Created by João Pedro Leite on 08/08/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

enum ServicosQuadrasServerOptions : String {
    case kBAR = "bar"
    case kVESTIARIO = "vestiário"
    case kARBITRO = "arbitro"
    case kCHURRASQUEIRA = "churrasqueira"
    case kESTACIONAMENTO = "estacionamento"
}

class ServicoQuadra {
    var type : ServicosQuadrasServerOptions!
    var description : String!
    
    init(type : ServicosQuadrasServerOptions, description : String) {
        self.type = type
        self.description = description
    }
    
    func getImage() -> UIImage {
        switch type! {
        case .kBAR :
            return UIImage(named: "bar")!
        case .kVESTIARIO:
            return UIImage(named: "locker")!
        case .kARBITRO:
            return UIImage(named: "referee")!
        case .kCHURRASQUEIRA:
            return UIImage(named: "grill")!
        case .kESTACIONAMENTO:
            return UIImage(named: "parking")!
        }
    }
}

class QuadraServicosController: UIViewController {
    
    @IBOutlet weak var tableInformacoes: UITableView!
    
    var quadra : QuadraDTO!
    var servicos = [ServicoQuadra]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Serviços"
        
        tableInformacoes.register(UINib(nibName: "ServicosCell", bundle: nil), forCellReuseIdentifier: "ServicosCell")
        tableInformacoes.allowsSelection = false
        
        for servicoServer in quadra.servicos ?? [] {
            if let servico = ServicosQuadrasServerOptions(rawValue: servicoServer) {
                for svDefault in AppConstants.ArrayServicosDefault {
                    if svDefault.type == servico {
                        servicos.append(svDefault)
                    }
                }
            }
        }
    }

}

//extension QuadraServicosController : UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return servicos.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicosCell", for: indexPath) as! ServicosCell
//
//        cell.lbServicoTitle.text = servicos[indexPath.row].type.rawValue.capitalized
//        cell.lbServicoDesc.text = servicos[indexPath.row].description
//        cell.imgServico.image = servicos[indexPath.row].getImage()
//        return cell
//    }
//
//}
