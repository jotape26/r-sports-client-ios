//
//  TimesController.swift
//  R Sports
//
//  Created by João Pedro Leite on 22/09/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class TimesController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var timesTable: UITableView!
    @IBOutlet weak var btnCriarTime: UIButton!
    
    var times = [TimeDTO]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnCriarTime.layer.cornerRadius = 5.0
        
        timesTable.register(UINib(nibName: "TimesCell", bundle: nil), forCellReuseIdentifier: "TimesCell")
        
        if !(SharedSession.shared.currentUser?.times?.isEmpty ?? true) {
            FirebaseService.getUserTimes { (userTimes) in
                self.times = userTimes
            }
        } else {
            alertView.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = nil
    }

}

extension TimesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimesCell") as! TimesCell
        return cell
    }
    
    
}
