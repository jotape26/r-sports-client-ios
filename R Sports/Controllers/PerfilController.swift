//
//  PerfilController.swift
//  R Sports
//
//  Created by João Leite on 27/05/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import Firebase

class PerfilController: UIViewController {

    //TextFields
    @IBOutlet weak var txtNome: UILabel!
    @IBOutlet weak var txtPosicao: UILabel!
    @IBOutlet weak var txtTotalJogos: UITextField!
    
    //Image
    @IBOutlet weak var userImage: UIImageView!
    
    //TableView
    @IBOutlet weak var infoTable: UITableView!
    
    var user: UserDTO? {
        didSet {
            updateValores()
        }
    }
    
    var informacoesTitle = ["Idade", "Celular", "E-mail", "Competitividade", "Procura Jogos Abertos?"]
    
    var informacoesData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userImage.setRounded()
        userImage.layer.borderWidth = 5.0
        userImage.layer.borderColor = AppConstants.ColorConstants.highlightGreen.cgColor
        
        infoTable.register(UINib(nibName: "DadosUsuarioCell", bundle: nil), forCellReuseIdentifier: "DadosUsuarioCell")
        infoTable.register(UINib(nibName: "LogoffCell", bundle: nil), forCellReuseIdentifier: "LogoffCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let cUser = SharedSession.shared.currentUser {
            self.user = cUser
        } else {
            self.view.startLoading()
            requestUserData()
        }
    }
    
    
    func requestUserData() {
        guard let user = Auth.auth().currentUser else { return }
        guard let number = user.phoneNumber else { return }
        
        FirebaseService.retrieveUserDatabaseRef(uid: number, success: { (refUser) in
            self.user = refUser
        })
    }
    
    func updateValores(){
        self.userImage.image = FilesManager.getProfilePicFromDisk()
        
        if let dt = self.user?.idade {
            let form = DateComponentsFormatter()
            form.maximumUnitCount = 2
            form.unitsStyle = .positional
            form.allowedUnits = [.year]
            
            if let str = form.string(from: dt, to: Date()) {
                if let time = Int(str.replacingOccurrences(of: "y", with: "")) {
                    self.informacoesData.append("\(time.description) anos")
                } else {
                    self.informacoesData.append("-")
                }
            } else {
                self.informacoesData.append("-")
            }
        } else {
            self.informacoesData.append("-")
        }

//        INCLUIR GENERO?
//        self.informacoesData.append(self.user?.genero ?? "")
        
        self.informacoesData.append(FirebaseService.getCurrentUser()?.phoneNumber ?? "")
        self.informacoesData.append(self.user?.email ?? "")
        self.informacoesData.append(self.user?.competitivade ?? "")
        
        if self.user?.procuraJogos ?? false {
            self.informacoesData.append("Sim")
        } else {
            self.informacoesData.append("Não")
        }
        
        self.txtNome.text = self.user?.nome
        self.txtPosicao.text = self.user?.posicao
        self.txtTotalJogos.text = "\(self.user?.totalJogos?.description ?? "0") jogos"
        
        self.view.stopLoading()
        self.infoTable.reloadData()
    }
    
    @IBAction func voltarBtnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PerfilController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if informacoesData.isEmpty {
            return 0
        } else {
            return informacoesData.count + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row != 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DadosUsuarioCell", for: indexPath) as! DadosUsuarioCell
            
            cell.lbTitulo.text = informacoesTitle[indexPath.row]
            cell.lbDetalhe.text = informacoesData[indexPath.row]
            
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "LogoffCell", for: indexPath) as! LogoffCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
