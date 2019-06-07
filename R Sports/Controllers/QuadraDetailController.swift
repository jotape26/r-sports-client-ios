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
    @IBOutlet weak var enderecoButton: UIButton!
    
    var selectedQuadra: QuadraDTO!
    let refDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendarView.tintColor = SharedSession.shared.standardColor
        calendarView.select(nil)
        
        imagensQuadra.contentScaleMode = .scaleAspectFill
        imagensQuadra.slideshowInterval = 5.0
        
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.title = selectedQuadra.nome
        
        var imagens = [UIImage]()
        
        enderecoButton.setTitle(selectedQuadra.endereco!, for: .normal)
        
        selectedQuadra.imagens?.forEach({ (imageURL) in
            guard let docID = selectedQuadra.documentID else { return }
            let path = "imagensQuadras/\(docID)/\(imageURL)"
            FirebaseService.getCourtImage(path: path, success: { (image) in
                imagens.append(image)
                
                if imagens.count == self.selectedQuadra.imagens?.count {
                    self.displayImages(images: imagens)
                }
            })
        })
    }
    
    func displayImages(images: [UIImage]){
        var inputs = [InputSource]()
        images.forEach { (image) in
            inputs.append(ImageSource(image: image))
        }
        
        imagensQuadra.setImageInputs(inputs)
    }
    
    @IBAction func enderecoBtnClick(_ sender: Any) {
        performSegue(withIdentifier: "DetailToMapSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MapController {
            vc.quadra = selectedQuadra
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
