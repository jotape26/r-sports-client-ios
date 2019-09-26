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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ConviteTimeCell", bundle: nil), forCellReuseIdentifier: "ConviteTimeCell")

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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConviteTimeCell", for: indexPath) as! ConviteTimeCell
        
        let time = times[indexPath.row]
//         Configure the cell...
        
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
