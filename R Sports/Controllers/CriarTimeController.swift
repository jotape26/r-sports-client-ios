//
//  CriarTimeController.swift
//  R Sports
//
//  Created by João Pedro Leite on 22/09/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import Photos
import ContactsUI
import NKVPhonePicker

class CriarTimeController: UIViewController {

    @IBOutlet weak var imgBrasao: UIImageView!
    @IBOutlet weak var tableJogadores: UITableView!
    @IBOutlet weak var btnCriarTime: UIButton!
    @IBOutlet weak var txtTelefone: NKVPhonePickerTextField!
    @IBOutlet weak var txtNomeTime: UITextField!
    
    var jogadores = [JogadorTimeDTO]()
    var genericImage = UIImage(named: "genericProfile")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableJogadores.register(UINib(nibName: "JogadoresCell", bundle: nil), forCellReuseIdentifier: "JogadoresCell")
        
        if let user = SharedSession.shared.currentUser {
            let jogador = JogadorTimeDTO()
            jogador.nome = user.nome
            jogador.telefone = user.telefone
            jogadores.append(jogador)
        }
        
        txtTelefone.delegate = self
        txtNomeTime.delegate = self
        
        btnCriarTime.layer.cornerRadius = 5.0
        imgBrasao.setRounded()
        imgBrasao.image = genericImage
        imgBrasao.layer.borderWidth = 5.0
        imgBrasao.layer.borderColor = AppConstants.ColorConstants.highlightGreen.cgColor
    }
    
    @IBAction func btnCriarClick(_ sender: Any) {
        guard let nome = txtNomeTime.text else {
            txtNomeTime.setTextInvalid()
            return
        }
        guard let image = imgBrasao.image, image != genericImage else {
            //TODO IMAGE ERROR
            return
        }
        
        let time = TimeDTO()
        time.nome = nome
        time.jogadores = jogadores
        
        FirebaseService.createTime(time: time,
                                   brasao: image, success: {
                                    self.dismiss(animated: true, completion: nil)
        }) {
            //TODO ERROR
        }
    }
    
    @IBAction func btnImagemClick(_ sender: Any) {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    self.presentPickerView()
                }
            })
        } else if photos == .authorized {
            self.presentPickerView()
        }
    }
    
    @IBAction func btnAddClick(_ sender: Any) {
        
        if let phoneNumber = txtTelefone.phoneNumber {
            if phoneNumber.count == 2 {
                let picker = CNContactPickerViewController()
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else if phoneNumber.count == 13 {
                let jogador = JogadorTimeDTO()
                jogador.telefone = "+\(phoneNumber)"
                jogadores.append(jogador)
                
                DispatchQueue.main.async {
                    self.tableJogadores.reloadData()
                }
            } else {
                //SHOW ERROR
                txtTelefone.resignFirstResponder()
                txtTelefone.setTextInvalid()
            }
        }
        
    }
    
    @IBAction func btnCloseCick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func presentPickerView(){
        
        let alert = UIAlertController(title: "Importar Imagem", message: "Selecione a fonte da imagem:", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Câmera", style: .default, handler: { (_) in
            let viewController = UIImagePickerController()
            viewController.delegate = self
            viewController.sourceType = .camera
            viewController.allowsEditing = true
            self.present(viewController, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Galeria", style: .default, handler: { (_) in
            let viewController = UIImagePickerController()
            viewController.delegate = self
            viewController.sourceType = .photoLibrary
            viewController.allowsEditing = true
            self.present(viewController, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (_) in
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func didSelectNumber(number: String, toContact: String) {
        var updatedNumber = number.formatToPhone()
 
        if updatedNumber.count == 9 {
            let alert = UIAlertController(title: "Atenção", message: "Por favor digite o código de 2 numeros referente ao DDD do contato.", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.placeholder = "Exemplo: 11"
            }
            
            alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { (action) in
                if let code = alert.textFields?[0].text, code.count == 2 {
                    updatedNumber = "\(code)\(updatedNumber)"
                    self.didSelectNumber(number: updatedNumber, toContact: toContact)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            
            return
        } else if updatedNumber.count >= 11 {
            if updatedNumber.count < 13 {
                updatedNumber = "55\(updatedNumber)"
            }
        }
        
        let jogador = JogadorTimeDTO()
        jogador.nome = toContact
        jogador.telefone = "+\(updatedNumber)"
        jogadores.append(jogador)
        
        DispatchQueue.main.async {
            self.tableJogadores.reloadData()
        }
    }
    
}

extension CriarTimeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jogadores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JogadoresCell") as! JogadoresCell
        
        let jogador = jogadores[indexPath.row]
        cell.phoneLabel.text = jogador.nome ?? jogador.telefone
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if indexPath.row != 0 {
            if editingStyle == .delete {
                
                // remove the item from the data model
                jogadores.remove(at: indexPath.row)
                //            tableView.deleteRows(at: [indexPath], with: .left)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    tableView.reloadData()
                    
                }
            }
        }
    }
}

extension CriarTimeController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let contactName = "\(contact.givenName) \(contact.familyName)"
        
        if contact.phoneNumbers.count == 1 {
            didSelectNumber(number: contact.phoneNumbers[0].value.stringValue, toContact: contactName)
        } else {
            let alert = UIAlertController(title: contactName, message: "Selecione o telefone que deseja utilizar:", preferredStyle: .actionSheet)
            
            for number in contact.phoneNumbers {
                alert.addAction(UIAlertAction(title: number.value.stringValue, style: .default, handler: { (_) in
                    
                    self.didSelectNumber(number: number.value.stringValue, toContact: contactName)
                }))
            }
            
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension CriarTimeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imgBrasao.image = image
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}
