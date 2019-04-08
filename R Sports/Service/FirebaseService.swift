//
//  FirebaseService.swift
//  R Sports
//
//  Created by João Leite on 07/04/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class FirebaseService {
    
    static func retrieveCourts(success: @escaping ([QuadraDTO])->()){
        Firestore.firestore().collection("quadras").getDocuments { (snap, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if let snap = snap {
                    var quadras : [QuadraDTO] = []
                    for document in snap.documents {
                        guard let quadra = try? QuadraDTO(JSON: document.data()) else { continue }
                        quadras.append(quadra)
                    }
                    success(quadras)
            }
        }
    }
    
    static func getCourtImage(path: String,
                              success: @escaping(UIImage)->()){
        Storage.storage().reference(withPath: path).getData(maxSize: 1 * 2048 * 2048) { (data, err) in
            if let err = err {
                print("Error downloading image: \(err)")
            } else if let data = data {
                if let courtImage = UIImage(data: data) {
                    success(courtImage)
                }
            }
        }
    }
    
}
