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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.startLoading()
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
        guard let number = user.phoneNumber else { return }
        
        FirebaseService.retrieveUserDatabaseRef(uid: number, success: { (refUser) in
            self.user = refUser
            self.view.stopLoading()
        })
    }
    
    func updateValores(){
        if let photoURL = user?.imagePath {
            userImage.startLoading()
            FirebaseService.getUserImage(path: photoURL, success: { (image) in
                self.userImage.image = image
                self.userImage.stopLoading()
            }) {
                self.userImage.stopLoading()
            }
        }
        
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
    
    @IBAction func testButton(_ sender: Any) {
        FirebaseService.logoutUser()
    }

}
