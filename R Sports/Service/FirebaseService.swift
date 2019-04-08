//
//  FirebaseService.swift
//  R Sports
//
//  Created by João Leite on 07/04/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseService {
    
    static func retrieveCourts(success: @escaping (QuadraDTO)->()){
        Firestore.firestore().collection("quadras").getDocuments { (snap, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let snap = snap {
                    var quadras : [QuadraDTO] = []
                    for document in snap.documents {
                        quadras.append(QuadraDTO(JSON: document.data()))
                    }
                    success(quadras)
                }
            }
        }
    }
    
}
