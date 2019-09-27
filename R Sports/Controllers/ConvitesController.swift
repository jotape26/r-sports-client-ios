//
//  ConvitesController.swift
//  R Sports
//
//  Created by João Pedro Leite on 26/09/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class ConvitesController: UITableViewController {
    
    var times = [TimeDTO]()
    var updateDelegate : TimeUpdateDelegate?
    @IBOutlet weak var btnVoltar: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ConviteTimeCell", bundle: nil), forCellReuseIdentifier: "ConviteTimeCell")

        requestTimes()
    }
    
    private func requestTimes(){
        self.times = []
        self.tableView.reloadData()
        
        
        if #available(iOS 13.0, *) {
            self.navigationItem.rightBarButtonItem = nil
        }

        SharedSession.shared.currentUser?.timesTemp?.forEach({ (timeID) in
            FirebaseService.getTime(docID: timeID, success: { (timedto) in
                self.times.append(timedto)
                if self.times.count == (SharedSession.shared.currentUser?.timesTemp?.count ?? 0) {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }, failure: {})
        })
    }

    @IBAction func btnVoltarClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConviteTimeCell", for: indexPath) as! ConviteTimeCell
        
        let time = times[indexPath.row]
//         Configure the cell...
        
        cell.timeID = time.timeID ?? ""
        cell.delegate = self
        cell.nomeTime.text = time.nome
        cell.lblConvite.text = "\(time.criadorName ?? "") convidou você!"
        
        time.getImage { (image) in
            cell.imgTime.image = image
            cell.imgTime.setRounded()
            cell.imgTime.layer.borderWidth = 5.0
            cell.imgTime.layer.borderColor = AppConstants.ColorConstants.highlightGreen.cgColor
        }

        return cell
    }

}

extension ConvitesController: TimeUpdateDelegate {
    func didUpdateTeams() {
        SharedSession.shared.reloadUser {
            self.view.stopLoading()
            self.updateDelegate?.didUpdateTeams()
            self.requestTimes()
        }
    }
    
    func willUpdateTeams() {
        self.view.startLoading()
    }
}
