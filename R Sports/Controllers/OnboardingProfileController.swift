//
//  OnboardingProfileController.swift
//  R Sports
//
//  Created by João Pedro Leite on 13/08/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import Photos

class OnboardingProfileController: UIViewController {

    @IBOutlet weak var contentScroll: UIScrollView!
    @IBOutlet weak var profileBorder: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtDataNascimento: SwiftMaskTextfield!
    @IBOutlet weak var txtPosicao: UITextField!
    @IBOutlet weak var txtCompetitividade: UITextField!
    
    @IBOutlet weak var segmentPartidas: UISegmentedControl!
    
    @IBOutlet weak var btnContinuar: UIButton!
    @IBOutlet weak var btnImagem: UIButton!
    
    var activeText : UITextField?
    var userImage : UIImage? {
        didSet {
            if userImage != nil {
                btnImagem.setImage(nil, for: .normal)
                profileImage.image = userImage
            } else {
                btnImagem.setImage(UIImage(named: "camera"), for: .normal)
                profileImage.image = UIImage(named: "genericProfile")
            }
        }
    }
    
    let pickerPosition = UIPickerView()
    let pickerCompetitivity = UIPickerView()
    
    let options = [["Ataque",
                    "Meio Campo",
                    "Defesa",
                    "Goleiro"],
                   ["Casual",
                    "Médio",
                    "Competitivo"]]
    
    lazy var inputToolbar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        var nextButton : UIBarButtonItem = {
            let btn = UIBarButtonItem(title: "Avançar", style: .plain, target: self, action: #selector(nextPressed))
            btn.tintColor = AppConstants.ColorConstants.defaultGreen
            return btn
        }()
        
        var previousButton : UIBarButtonItem = {
            let btn = UIBarButtonItem(title: "Voltar", style: .plain, target: self, action: #selector(previousPressed))
            btn.tintColor = AppConstants.ColorConstants.defaultGreen
            return btn
        }()
        
        var spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton, previousButton, spaceButton, nextButton, spaceButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtNome.delegate = self
        txtNome.inputAccessoryView = inputToolbar
        txtEmail.delegate = self
        txtEmail.inputAccessoryView = inputToolbar
        txtDataNascimento.delegate = self
        txtDataNascimento.inputAccessoryView = inputToolbar
        txtPosicao.delegate = self
        txtPosicao.inputAccessoryView = inputToolbar
        txtCompetitividade.delegate = self
        txtCompetitividade.inputAccessoryView = inputToolbar
        
        pickerPosition.delegate = self
        pickerPosition.dataSource = self
        
        pickerCompetitivity.delegate = self
        pickerCompetitivity.dataSource = self
        
        txtPosicao.inputView = pickerPosition
        txtCompetitividade.inputView = pickerCompetitivity
        
        
        profileBorder.setRounded()
        profileImage.setRounded()
        
        btnContinuar.layer.cornerRadius = 5.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        userImage = FilesManager.getProfilePicFromDisk()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func btnImageClick(_ sender: Any) {
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
    
    @IBAction func btnContinuarClick(_ sender: Any) {
        if validateFields() {
            
            
            let form = DateFormatter()
            form.dateFormat = "dd/MM/yyyy"
            
            
            
            var userData : [String : Any] = [ProfileConstants.NAME : txtNome.text ?? "",
                                             ProfileConstants.EMAIL : txtEmail.text ?? "",
                                             ProfileConstants.POSITION : txtPosicao.text ?? "",
                                             ProfileConstants.COMPETITIVITY : txtCompetitividade.text ?? "",
                                             ProfileConstants.SEARCHING_GAMES : segmentPartidas.selectedSegmentIndex == 1 ? true : false,
                                             "times" : [],
                                             "gols" : 0,
                                             "assistencias": 0]
            
            if let date = form.date(from: txtDataNascimento.text ?? "") {
                userData.updateValue(date, forKey: ProfileConstants.AGE)
            }
            
            FirebaseService.setUserData(data: userData)
            performSegue(withIdentifier: "PlaystyleToFinishSegue", sender: nil)
        }
    }
    
    func validateFields() -> Bool {
        if txtNome.text ?? "" == "" {
            txtNome.setTextInvalid()
            return false
        }
        
        if txtDataNascimento.text == nil {
            txtDataNascimento.setTextInvalid()
            return false
        }
        
        if txtEmail.text ?? "" == "" {
            txtEmail.setTextInvalid()
            return false
        }
        
        if txtPosicao.text == "" {
            txtPosicao.setTextInvalid()
            return false
        }
        
        if txtCompetitividade.text == "" {
            txtCompetitividade.setTextInvalid()
            return false
        }
        
        return true
    }
    
    func presentPickerView(){
        
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
    
    @objc func nextPressed() {
        if let btn = activeText {
            if btn == txtNome {
                let t = txtEmail.frame
                t.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0))
                contentScroll.scrollRectToVisible(t, animated: true)
                txtEmail.becomeFirstResponder()
            } else if btn == txtEmail {
                let t = txtDataNascimento.frame
                t.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0))
                contentScroll.scrollRectToVisible(t, animated: true)
                txtDataNascimento.becomeFirstResponder()
            } else if btn == txtDataNascimento {
                let t = txtPosicao.frame
                t.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0))
                contentScroll.scrollRectToVisible(t, animated: true)
                txtPosicao.becomeFirstResponder()
            } else if btn == txtPosicao {
                let t = txtCompetitividade.frame
                t.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0))
                contentScroll.scrollRectToVisible(t, animated: true)
                txtCompetitividade.becomeFirstResponder()
            } else if btn == txtCompetitividade {
                txtCompetitividade.resignFirstResponder()
            }
        }
    }
    
    @objc func previousPressed() {
        if let btn = activeText {
            if btn == txtNome {
                txtNome.resignFirstResponder()
            } else if btn == txtEmail {
                let t = txtNome.frame
                t.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -60, right: 0))
                contentScroll.scrollRectToVisible(t, animated: true)
                txtNome.becomeFirstResponder()
            } else if btn == txtDataNascimento {
                let t = txtEmail.frame
                t.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -60, right: 0))
                contentScroll.scrollRectToVisible(t, animated: true)
                txtEmail.becomeFirstResponder()
            } else if btn == txtPosicao {
                let t = txtDataNascimento.frame
                t.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -60, right: 0))
                contentScroll.scrollRectToVisible(t, animated: true)
                txtDataNascimento.becomeFirstResponder()
            } else if btn == txtCompetitividade {
                let t = txtPosicao.frame
                t.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -60, right: 0))
                contentScroll.scrollRectToVisible(t, animated: true)
                txtPosicao.becomeFirstResponder()
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        contentScroll.contentInset = contentInsets
        contentScroll.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        contentScroll.contentInset = .zero
        contentScroll.scrollIndicatorInsets = .zero
    }

    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        self.activeText = textField
    }
}

extension OnboardingProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            userImage = image
            FilesManager.saveImageToDisk(image: image)
            FirebaseService.saveUserImage(userImage: image, success: {}) {}
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}

extension OnboardingProfileController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerPosition {
            return options[0].count
        } else {
            return options[1].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerPosition {
            return options[0][row]
        } else {
            return options[1][row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerPosition {
            txtPosicao.text = options[0][row]
        } else {
            txtCompetitividade.text = options[1][row]
        }
    }
}
