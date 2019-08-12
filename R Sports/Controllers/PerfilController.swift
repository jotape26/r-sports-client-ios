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
    
    var informacoesTitle = ["Idade", "Genero", "Celular", "E-mail", "Competitividade", "Procura Jogos Abertos?"]
    
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
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.startLoading()
        requestUserData()
    }
    
    
    func requestUserData() {
        guard let user = Auth.auth().currentUser else { return }
        guard let number = user.phoneNumber else { return }
        
        FirebaseService.retrieveUserDatabaseRef(uid: number, success: { (refUser) in
            self.user = refUser
        })
    }
    
    func updateValores(){
        if let photoURL = user?.imagePath {
            FirebaseService.getUserImage(path: photoURL, success: { [weak self] (image) in
                
                guard let weakSelf = self else { return }
                weakSelf.userImage.image = image
                
                weakSelf.informacoesData.append(weakSelf.user?.idade?.description ?? "")
                weakSelf.informacoesData.append(weakSelf.user?.genero ?? "")
                weakSelf.informacoesData.append(FirebaseService.getCurrentUser()?.phoneNumber ?? "")
                weakSelf.informacoesData.append(weakSelf.user?.email ?? "")
                weakSelf.informacoesData.append(weakSelf.user?.competitivade ?? "")
                
                if weakSelf.user?.procuraJogos ?? false {
                    weakSelf.informacoesData.append("Sim")
                } else {
                    weakSelf.informacoesData.append("Não")
                }
                
                weakSelf.txtNome.text = weakSelf.user?.nome
                weakSelf.txtPosicao.text = weakSelf.user?.posicao
                weakSelf.txtTotalJogos.text = "\(weakSelf.user?.totalJogos?.description ?? "0") jogos"
                
                weakSelf.view.stopLoading()
                weakSelf.infoTable.reloadData()
            }) {
                self.view.stopLoading()
            }
        }
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
        
        if indexPath.row != 6 {
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
