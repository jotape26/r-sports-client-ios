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
import GoogleSignIn

class FirebaseService {
    
    //MARK: - Auth Methods
    
    static func loginWith(credential: AuthCredential,
                          complete: @escaping(Bool)->()) {
        Auth.auth().signInAndRetrieveData(with: credential) { (result, err) in
            if err != nil {
                complete(false)
                return
            }else if let result = result {
                FirebaseService.createUserDatabaseReference(user: result.user)
                complete(true)
            }
        }
    }
    
    static func logoutUser(){
        do {
            try Auth.auth().signOut()
            
            let authVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! AuthController
            authVC.modalTransitionStyle = .crossDissolve
            
            UIApplication.shared.keyWindow?.visibleViewController()?.present(authVC, animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    static func getCurrentUser() -> User?{
        return Auth.auth().currentUser
    }
    
    //MARK: - Firestore Methods
    static func retrieveCourts(cidade: String?,
                               success: @escaping ([QuadraDTO])->()){
        
        let request = Firestore.firestore().collection("quadras")
        
        if let cidade = cidade{
            request.whereField("cidade", isGreaterThanOrEqualTo: cidade)
        }
        
        request.getDocuments { (snap, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if let snap = snap {
                var quadras : [QuadraDTO] = []
                for document in snap.documents {
                    guard let quadra = QuadraDTO(JSON: document.data()) else { continue }
                    quadra.documentID = document.documentID
                    quadras.append(quadra)
                }
                success(quadras)
            }
        }
    }
    
    static func createUserDatabaseReference(user: User){
        guard let number = user.phoneNumber else { return }
        Firestore.firestore().collection("users").document(number).setData([:])
    }
    
    static func retrieveUserDatabaseRef(uid: String,
                                        success: @escaping(UserDTO)->()) {
        Firestore.firestore().collection("users").document(uid).getDocument { (snap, err) in
            if let err = err {
                
            } else {
                guard let userData = snap?.data() else { return }
                guard let user = UserDTO(JSON: userData) else { return }
                success(user)
            }
        }
    }
    
    static func setUserData(data: [String: Any]) {
        
        guard let user = Auth.auth().currentUser else { return }
        guard let number = user.phoneNumber else { return }
        Firestore.firestore().collection("users").document(number).setData(data, merge: true)
    }
    
    //MARK: - Storage Methods
    static func getCourtImage(path: String,
                              success: @escaping(UIImage)->(),
                              failure: @escaping()->()){
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
    
    static func getUserImage(path: String,
                              success: @escaping(UIImage)->(),
                              failure: @escaping()->()){
        Storage.storage().reference(withPath: path).getData(maxSize: 1 * 2048 * 2048) { (data, err) in
            if let err = err {
                print("Error downloading image: \(err)")
            } else if let data = data {
                if let userImage = UIImage(data: data) {
                    success(userImage)
                }
            }
        }
    }
    
    static func saveUserImage(userImage: UIImage,
                              success: @escaping()->(),
                              failure: @escaping()->()) {
        guard let user = Auth.auth().currentUser else { return }
        guard let number = user.phoneNumber else { return }
        guard let photoData = userImage.jpegData(compressionQuality: 1.0) else { return }
        
        Storage.storage().reference(withPath: "userImages/\(number)/profilePic.jpg").putData(photoData, metadata: nil) { metadata, error in
            
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                failure()
                return
            }
            
            let userData : [String : Any] = ["userImage" : metadata.path ?? ""]
            FirebaseService.setUserData(data: userData)
            success()
            
        }
    }
    
}
