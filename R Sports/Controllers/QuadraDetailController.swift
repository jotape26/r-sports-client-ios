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

class QuadraDetailController: UIViewController {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var imagensQuadra: ImageSlideshow!
    @IBOutlet weak var tableInformacoes: UITableView!
    
    var selectedQuadra: QuadraDTO!
    let refDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendarView.tintColor = SharedSession.shared.standardColor
        calendarView.select(nil)
        
        imagensQuadra.contentScaleMode = .scaleAspectFill
        imagensQuadra.slideshowInterval = 5.0
        
        tableInformacoes.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "HeaderCell")
        tableInformacoes.register(UINib(nibName: "EnderecoCell", bundle: nil), forCellReuseIdentifier: "EnderecoCell")
        tableInformacoes.delegate = self
        tableInformacoes.dataSource = self
        tableInformacoes.isScrollEnabled = false
        
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.title = selectedQuadra.nome
        
        var imagens = [UIImage]()
        
        imagensQuadra.startLoading()
        selectedQuadra.imagens?.forEach({ (imageURL) in
            guard let docID = selectedQuadra.documentID else { return }
            let path = "imagensQuadras/\(docID)/\(imageURL)"
            FirebaseService.getCourtImage(path: path, success: { (image) in
                imagens.append(image)
                
                if imagens.count == self.selectedQuadra.imagens?.count {
                    self.displayImages(images: imagens)
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
        if let vc = segue.destination as? MapController {
            vc.quadra = selectedQuadra
        } else if let vc = segue.destination as? CriarReservaController {
            vc.dataDoJogo = calendarView.selectedDate ?? Date()
            vc.selectedQuadra = selectedQuadra
        }
    }
}

extension QuadraDetailController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if date < Date() {
            calendarView.select(Date(), scrollToDate: true)
            calendarView.deselect(Date())
        } else {
            let df = DateFormatter()
            df.dateFormat = "dd/MM/yyyy"
        }
        
        performSegue(withIdentifier: "DetailToReserveSegue", sender: nil)
    }
}

extension QuadraDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EnderecoCell") as! EnderecoCell
            cell.enderecoLabel.text = "\(selectedQuadra.endereco ?? "") \n\(selectedQuadra.cidade ?? "")"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
            
            if indexPath.row == 1 {
                cell.titleLabel.text = "Informações da Quadra"
            } else if indexPath.row == 2 {
                cell.titleLabel.text = "Serviços"
                selectedQuadra.servicos?.forEach({ (servico) in
                    if servico == "churrasqueira" {
                        cell.addImageToIconStack(image: UIImage(named: "barbecue")!)
                    }
                })
            }
            
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            performSegue(withIdentifier: "DetailToMapSegue", sender: nil)
        }
    }
    
}
