//
//  QuadraDetailController.swift
//  R Sports
//
//  Created by João Leite on 27/05/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import FSCalendar
import ImageSlideshow
import Presentr
import Cosmos

class QuadraDetailController: UIViewController {
    
    @IBOutlet weak var imagensQuadra: ImageSlideshow!
    @IBOutlet weak var servicosCollection: UICollectionView!
    @IBOutlet weak var lbNome: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var btnEndereco: UIButton!
    @IBOutlet weak var btnReservarSolo: UIButton!
    @IBOutlet weak var btnReservarTime: UIButton!
    
    var selectedQuadra: QuadraDTO!
    var selectedTime: TimeDTO?
    let refDate = Date()
    var servicos = [ServicoQuadra]()
    var imagens = [UIImage]()
    
    private let presenter: Presentr = {
        let width = ModalSize.fluid(percentage: 0.9)
        let height = ModalSize.fluid(percentage: 0.25)
        let center = ModalCenterPosition.center
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVerticalFromTop
        customPresenter.dismissTransitionType = .coverVerticalFromTop
        customPresenter.roundCorners = true
        customPresenter.backgroundColor = .clear
        return customPresenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        calendarView.tintColor = AppConstants.ColorConstants.defaultGreen
//        calendarView.select(nil)
//        calendarView.delegate = self
        
        imagensQuadra.contentScaleMode = .scaleAspectFill
        imagensQuadra.slideshowInterval = 3.0
        
        btnReservarSolo.layer.cornerRadius = 5.0
        btnReservarTime.layer.cornerRadius = 5.0

        lbNome.text = selectedQuadra.nome
        ratingView.rating = selectedQuadra.rating ?? 5.0
        
        let end = "\(selectedQuadra.endereco ?? "") \(selectedQuadra.numeroEndereco ?? "")"
        btnEndereco.setTitle(end, for: .normal)
        
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.title = selectedQuadra.nome
        
        imagensQuadra.startLoading()
        selectedQuadra.servicos?.forEach({ (servicoQuadra) in
            if let servico = ServicosQuadrasServerOptions(rawValue: servicoQuadra) {
                for svDefault in AppConstants.ArrayServicosDefault {
                    if svDefault.type == servico {
                        servicos.append(svDefault)
                    }
                }
            }
        })
        
        selectedQuadra.imagens?.forEach({ (imageURL) in
            guard let docID = selectedQuadra.documentID else { return }
            let path = "imagensQuadras/\(docID)/\(imageURL)"
            FirebaseService.getCourtImage(path: path, success: { (image) in
                self.imagens.append(image)
                
                if self.imagens.count == self.selectedQuadra.imagens?.count {
                    self.displayImages(images: self.imagens)
                }
            }, failure: {})
        })
    }
    
    func displayImages(images: [UIImage]){
        var inputs = [InputSource]()
        images.forEach { (image) in
            inputs.append(ImageSource(image: image))
        }
        
        imagensQuadra.setImageInputs(inputs)
        imagensQuadra.stopLoading()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let contrl = segue.destination as? CriarReservaController {
            contrl.quadra = selectedQuadra
            
            if let time = selectedTime {
                contrl.time = time
            }
        } else if let contrl = segue.destination as? MapController {
            contrl.quadra = selectedQuadra
        }
    }
    
    @IBAction func btnEnderecoClick(_ sender: Any) {
        performSegue(withIdentifier: "DetailToMapSegue", sender: nil)
    }
    
    @IBAction func btnSoloClick(_ sender: Any) {
        let alert = UIAlertController(title: "Reservar Sozinho", message: "Essa opção permite que a reserva feita integralmente no seu nome. Não se preocupe, você poderá convidar participantes após a criação da reserva.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            self.performSegue(withIdentifier: "DetailToReserveSegue", sender: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnTimeClick(_ sender: Any) {
        let alert = UIAlertController(title: "Reservar com Time", message: "Selecione o time que você gostaria de convidar para jogar:", preferredStyle: .alert)
        
        for time in SharedSession.shared.currentUser?.times ?? [:] {
            alert.addAction(UIAlertAction(title: time.key, style: .default, handler: { [weak self] (_) in
                
                self?.view.startLoading()
                FirebaseService.getTime(docID: time.value, success: { (selectTime) in
                    self?.view.stopLoading()
                    
                    self?.selectedTime = selectTime
                    self?.performSegue(withIdentifier: "DetailToReserveSegue", sender: nil)
                }) {
                    AlertsHelper.showErrorMessage(message: "Não foi possivel baixar as informações do seu time. Por favor, tente novamente.")
                }

            }))
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

//extension QuadraDetailController: FSCalendarDelegate, FSCalendarDelegateAppearance {
//
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
//        if Calendar.current.isDateInToday(date) {
//            return .white
//        } else {
//            if date < Date() {
//                return .lightGray
//            } else {
//                return .black
//            }
//        }
//    }
//
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//        if Calendar.current.isDateInToday(date) || date > Date() {
//            return true
//        } else {
//            AlertsHelper.showErrorMessage(message: "Data Invalida")
//            return false
//        }
//    }
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//
//        if Calendar.current.isDateInToday(date) || date > Date(){
//            calendarView.select(Date(), scrollToDate: true)
//            performSegue(withIdentifier: "DetailToReserveSegue", sender: nil)
//        }
//    }
//}

extension QuadraDetailController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return servicos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicosCollectionCell", for: indexPath) as! ServicosCollectionCell
        
        cell.lbServico.text = servicos[indexPath.row].type.rawValue.capitalized
        cell.imgServico.image = servicos[indexPath.row].getImage()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let controller = ServicoController.create(servico: servicos[indexPath.row])
        customPresentViewController(presenter, viewController: controller, animated: true)
    }
}

//extension QuadraDetailController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EnderecoCell") as! EnderecoCell
//            cell.enderecoLabel.text = "\(selectedQuadra.endereco ?? "") \n\(selectedQuadra.cidade ?? "")"
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
//
//            if indexPath.row == 1 {
//                cell.titleLabel.text = "Informações da Quadra"
//            } else if indexPath.row == 2 {
//                cell.titleLabel.text = "Serviços"
//            }
//
//            cell.accessoryType = .disclosureIndicator
//
//            return cell
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        if indexPath.row == 0 {
//        } else if indexPath.row == 2 {
//            performSegue(withIdentifier: "DetailToServicosSegue", sender: nil)
//        }
//    }
//
//}
