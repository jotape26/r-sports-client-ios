//
//  TimesController.swift
//  R Sports
//
//  Created by João Pedro Leite on 22/09/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

protocol TimesUpdateDelegate {
    func didUpdateTimes()
}

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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = nil
        validateTimes()
    }
    
    @IBAction func criarTimesClick(_ sender: Any) {
        performSegue(withIdentifier: "CreateTimeSegue", sender: nil)
    }
    
    fileprivate func validateTimes() {
        if !(SharedSession.shared.currentUser?.times?.isEmpty ?? true) {
            alertView.isHidden = false
            self.view.startLoading()
            FirebaseService.getUserTimes { (userTimes) in
                self.view.stopLoading()
                self.times = userTimes
                self.timesTable.reloadData()
            }
        } else {
            alertView.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let contrl = segue.destination as? CriarTimeController {
            
        }
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

extension TimesController: TimesUpdateDelegate {
    func didUpdateTimes() {
        validateTimes()
    }
}
