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
    @IBOutlet weak var txtIdade: UITextField!
    @IBOutlet weak var txtGenero: UITextField!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtPosicao: UITextField!
    @IBOutlet weak var txtTotalJogos: UITextField!
    @IBOutlet weak var txtProcuraJogos: UITextField!
    @IBOutlet weak var txtCompetitividade: UITextField!
    
    //Image
    @IBOutlet weak var userImage: UIImageView!
    
    var user: UserDTO? {
        didSet {
            updateValores()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userImage.setRounded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestUserData()
    }
    
    func requestUserData() {
        guard let user = Auth.auth().currentUser else { return }
        
        userImage.downloadImage(from: user.photoURL!)
        
        FirebaseService.retrieveUserDatabaseRef(uid: user.uid, success: { (refUser) in
            self.user = refUser
        })
    }
    
    func updateValores(){
        txtIdade.text = user?.idade?.description
        txtNome.text = user?.nome
        txtGenero.text = user?.genero
        txtPosicao.text = user?.posicao
        txtTotalJogos.text = user?.totalJogos?.description
        
        if user?.procuraJogos ?? false {
            txtProcuraJogos.text = "Sim"
        } else {
            txtProcuraJogos.text = "Não"
        }
        
        txtCompetitividade.text = user?.competitivade
        
    }

}
