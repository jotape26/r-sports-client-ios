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
    
    //MARK: - Auth Methods
    
    static func loginWith(credential: AuthCredential,
                          complete: @escaping(Bool)->()) {
        Auth.auth().signInAndRetrieveData(with: credential) { (result, err) in
            if err != nil {
                complete(false)
                return
            }
            // User is signed in
            // ...
            complete(true)
        }
    }
    
    static func getCurrentUser() -> User?{
        return Auth.auth().currentUser
    }
    
    //MARK: - Firestore Methods
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
    
    //MARK: - Storage Methods
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
