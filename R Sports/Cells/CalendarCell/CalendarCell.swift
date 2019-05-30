//
//  CalendarCell.swift
//  R Sports
//
//  Created by João Leite on 28/05/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarCell: UITableViewCell {
    
    @IBOutlet weak var calendarView: FSCalendar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(delegate: FSCalendarDelegate, dataSource: FSCalendarDataSource) {
        self.calendarView.delegate = delegate
        self.calendarView.dataSource = dataSource
    }
    
}
