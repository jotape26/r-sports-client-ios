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
    
    //Button
    @IBOutlet weak var btnEdit: UIButton!
    
    let btnExit : UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(testButton(_:)))
        return btn
    }()
    
    var user: UserDTO? {
        didSet {
            updateValores()
        }
    }
    
    var editState = false {
        didSet {
            toggleEditState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userImage.setRounded()
        btnEdit.layer.cornerRadius = 5.0
        
        toggleEditState()
        
        txtIdade.setBottomBorder(withColor: UIColor.lightGray)
        txtGenero.setBottomBorder(withColor: UIColor.lightGray)
        txtNome.setBottomBorder(withColor: UIColor.lightGray)
        txtPosicao.setBottomBorder(withColor: UIColor.lightGray)
        txtTotalJogos.setBottomBorder(withColor: UIColor.lightGray)
        txtProcuraJogos.setBottomBorder(withColor: UIColor.lightGray)
        txtCompetitividade.setBottomBorder(withColor: UIColor.lightGray)
        
        self.navigationController?.topViewController?.navigationItem.setLeftBarButton(btnExit, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestUserData()
    }
    
    func toggleEditState(){
        txtNome.isEnabled = editState
        txtPosicao.isEnabled = editState
        txtTotalJogos.isEnabled = editState
        txtProcuraJogos.isEnabled = editState
        txtCompetitividade.isEnabled = editState
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
    
    @IBAction func editBtnClick(_ sender: Any) {
        editState = true
    }
    
    @objc func testButton(_ sender: Any) {
        FirebaseService.logoutUser()
    }

}
