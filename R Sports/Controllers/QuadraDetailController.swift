//
//  QuadraDetailController.swift
//  R Sports
//
//  Created by João Leite on 27/05/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import FSCalendar
class QuadraDetailController: UIViewController {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var tsLb: UILabel!
    
    let refDate = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendarView.tintColor = SharedSession.shared.standardColor
        calendarView.select(nil)
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
            tsLb.text = df.string(from: date)
        }
    }
    
    
}
