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
import Geofirestore
import GoogleSignIn
import CoreLocation

class FirebaseService {
    
    static var courtQuery: GFSCircleQuery?
    
    //MARK: - Auth Methods
    static func loginWith(credential: AuthCredential,
                          register: Bool = false,
                          complete: @escaping(Bool)->()) {
        Auth.auth().signInAndRetrieveData(with: credential) { (result, err) in
            if err != nil {
                complete(false)
                return
            }else if let result = result {
                if register {
                    FirebaseService.createUserDatabaseReference(user: result.user)
                }
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
    static func getDocumentReference() -> DocumentReference? {
        guard let number = FirebaseService.getCurrentUser()?.phoneNumber else { return nil }
        return Firestore.firestore().collection("users").document(number)
    }
    
    static func retrieveCourts(userLocation: CLLocation,
                               success: @escaping (QuadraDTO)->()){
        
        let request = Firestore.firestore().collection("quadras")
        let geoRequest = GeoFirestore(collectionRef: request)
        courtQuery = geoRequest.query(withCenter: userLocation, radius: 10.0)
        
        _ = courtQuery?.observe(.documentEntered) { (key, _) in
            request.document(key!).getDocument(completion: { (snap, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else if let snap = snap {
                    if let doc = snap.data() {
                        guard let quadra = QuadraDTO(JSON: doc) else { return }
                        quadra.documentID = key!
                        success(quadra)
                    }
                }
            })
        }
    }
    
    @objc static func stopCourtQuery() {
        courtQuery?.removeAllObservers()
    }
    
    static func createUserDatabaseReference(user: User){
        guard let number = user.phoneNumber else { return }
        Firestore.firestore().collection("users").document(number).setData([:])
    }
    
    static func retrieveUserDatabaseRef(uid: String,
                                        success: @escaping(UserDTO)->()) {
        Firestore.firestore().collection("users").document(uid).getDocument { (snap, err) in
            if err != nil {
                
            } else {
                guard let userData = snap?.data() else { return }
                guard let user = UserDTO(JSON: userData) else { return }
                success(user)
            }
        }
    }
    
    static func getUserReservations(success: @escaping([ReservaListaDTO])->()) {
        
        var reservas = [ReservaListaDTO]()
        
        SharedSession.shared.currentUser?.reservas?.forEach({ (reservaID) in
            Firestore.firestore().collection("reservas").document(reservaID).getDocument(completion: { (snap, err) in
                if let snapData = snap?.data(), let resDTO = ReservaListaDTO(JSON: snapData) {
                    resDTO.docID = snap?.documentID
                    reservas.append(resDTO)
                    if reservas.count == SharedSession.shared.currentUser!.reservas!.count {
                        success(reservas)
                    }
                }
            })
        })
        
    }
    
    static func getQuadraById(quadraID : String,
                              success : @escaping(QuadraDTO)->()) {
        Firestore.firestore().collection("quadras").document(quadraID).getDocument { (snap, err) in
            if let snapData = snap?.data(), let quadra = QuadraDTO(JSON: snapData) {
                success(quadra)
            }
        }
    }
    
    static func setUserData(data: [String: Any]) {
        
        guard let user = Auth.auth().currentUser else { return }
        guard let number = user.phoneNumber else { return }
        Firestore.firestore().collection("users").document(number).setData(data, merge: true)
    }
    
    static func getPlayerDetails(jogador: UserDTO,
                                 found: @escaping(UserDTO)->(),
                                 notFound: @escaping()->()) {
        
        Firestore.firestore().collection("users").document(jogador.telefone ?? "").getDocument { (snap, err) in
            if err != nil {
                notFound()
            }
            
            guard let userData = snap?.data() else {
                notFound()
                return
            }
            
            guard let user = UserDTO(JSON: userData) else {
                notFound()
                return
            }
            
            jogador.nome = user.nome
            found(jogador)
        }
    }
    
    static func createReserva(reserva : ReservaDTO,
                              success : @escaping()->(),
                              failure : @escaping()->()) {
        
        if !reserva.getExportData().isEmpty {
            let reservaDocument = Firestore.firestore().collection("reservas").document()
            reservaDocument.setData(reserva.getExportData()) { (err) in
                if err != nil {
                    failure()
                } else {
                    RSportsService.processNewReservation(reservaID: reservaDocument.documentID)
                    FirebaseService.addReservaToUser(reservaID: reservaDocument.documentID)
                    success()
                }
            }
        } else {
            failure()
        }
    }
    
    static func addReservaToUser(reservaID : String) {
        guard let user = Auth.auth().currentUser else { return }
        guard let number = user.phoneNumber else { return }
        
        Firestore.firestore().collection("users").document(number).setData(["reservas" : [reservaID]], merge: true, completion: nil)
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
            
            let userData : [String : Any] = [ProfileConstants.IMAGEPATH : metadata.path ?? ""]
            FirebaseService.setUserData(data: userData)
            success()
            
        }
    }
    
}
