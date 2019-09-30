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
            
            UIApplication.shared.keyWindow?.rootViewController = authVC
//            UIApplication.shared.keyWindow?.visibleViewController()?.present(authVC, animated: true, completion: nil)
            
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
                               maximumDistance : Double,
                               minimumRating : Double,
                               success: @escaping (QuadraDTO)->()){
        
        let request = Firestore.firestore().collection("quadras")
        let geoRequest = GeoFirestore(collectionRef: request)
        courtQuery = geoRequest.query(withCenter: userLocation, radius: maximumDistance)
        
        _ = courtQuery?.observe(.documentEntered) { (key, _) in
            request.document(key!).getDocument(completion: { (snap, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else if let snap = snap {
                    if let doc = snap.data() {
                        guard let quadra = QuadraDTO(JSON: doc) else { return }
                        quadra.documentID = key!
                        if quadra.rating ?? 0 >= minimumRating {
                            success(quadra)
                        }
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
                user.telefone = uid
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
    
    static func getReservation(reserva: String,
                               success: @escaping(ReservaListaDTO)->()) {
        
        Firestore.firestore().collection("reservas").document(reserva).getDocument(completion: { (snap, err) in
            if let snapData = snap?.data(), let resDTO = ReservaListaDTO(JSON: snapData) {
                resDTO.docID = snap?.documentID
                success(resDTO)
            }
        })
    }
    
    static func getCourt(quadra: String,
                         success: @escaping(QuadraDTO)->()) {
        
        Firestore.firestore().collection("quadras").document(quadra).getDocument(completion: { (snap, err) in
            if let snapData = snap?.data(), let resDTO = QuadraDTO(JSON: snapData) {
                resDTO.documentID = snap?.documentID
                success(resDTO)
            }
        })
    }
    
    static func getUserTimes(success: @escaping([TimeDTO])->()) {
        var times = [TimeDTO]()
        if SharedSession.shared.currentUser?.times?.isEmpty ?? true {
            success(times)
        } else {
            for time in SharedSession.shared.currentUser?.times ?? [:] {
                Firestore.firestore().collection("times").document(time.value).getDocument(completion: { (snap, err) in
                    if let snapData = snap?.data(), let timeDTO = TimeDTO(JSON: snapData) {
                        timeDTO.timeID = snap?.documentID
                        times.append(timeDTO)
                        
                        if times.count == SharedSession.shared.currentUser!.times!.count {
                            success(times)
                        }
                    }
                })
            }
        }
    }
    
    static func getTime(docID: String,
                        success: @escaping(TimeDTO)->(),
                        failure: @escaping()->()) {

        
        Firestore.firestore().collection("times").document(docID).getDocument(completion: { (snap, err) in
            if let snapData = snap?.data(), let timeDTO = TimeDTO(JSON: snapData) {
                timeDTO.timeID = snap?.documentID
                success(timeDTO)
            } else {
                failure()
            }
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
    
    static func createReserva(reserva : CriacaoReservaDTO,
                              success : @escaping()->(),
                              failure : @escaping()->()) {
        
        if !reserva.getExportData().isEmpty {
            let reservaDocument = Firestore.firestore().collection("reservas").document()
            reservaDocument.setData(reserva.getExportData()) { (err) in
                if err != nil {
                    failure()
                } else {
                    RSportsService.processNewReservation(reservaID: reservaDocument.documentID)
                    success()
                }
            }
        } else {
            failure()
        }
    }
    
    static func createTime(time : TimeDTO,
                           brasao: UIImage?,
                           success : @escaping(String)->(),
                           failure : @escaping()->()) {
        
        var data = time.getCreationData()
        guard !data.isEmpty else {
            failure()
            return
        }
        
        let document = Firestore.firestore().collection("times").document()
        
        
        if let brasao = brasao {
            FirebaseService.setTimeImage(docID: document.documentID, brasao: brasao, success: {

                data.updateValue("brasaoTime.jpg", forKey: "imagemBrasao")
                
                document.setData(data) { (err) in
                    if err != nil {
                        failure()
                    } else {
                        success(document.documentID)
                    }
                }
            }) {
                failure()
            }
        } else {
            document.setData(data) { (err) in
                if err != nil {
                    failure()
                } else {
                    success(document.documentID)
                }
            }
        }
        
    }
    
    static func getEventos(success : @escaping([EventoDTO])->()) {
        Firestore.firestore().collection("eventos").getDocuments { (snap, err) in
            if let docs = snap?.documents {
                var events = [EventoDTO]()
                
                docs.forEach { (docSnap) in
                    if let event = try? EventoDTO(JSON: docSnap.data()) {
                        event.documentID = docSnap.documentID
                        events.append(event)
                    }
                }
                
                success(events)
            }
        }
    }
    
    //MARK: - Storage Methods
    static func setTimeImage(docID: String,
                             brasao: UIImage,
                             success : @escaping()->(),
                             failure : @escaping()->()) {
        guard let photoData = brasao.jpegData(compressionQuality: 1.0) else { failure(); return }
        Storage.storage().reference(withPath: "timesImages/\(docID)/brasaoTime.jpg").putData(photoData, metadata: .none) { meta, err in
            if err != nil {
                failure()
            } else {
                success()
            }
        }
    }
    
    static func getTimeImage(docID: String,
                              success: @escaping(UIImage)->(),
                              failure: @escaping()->()){
        Storage.storage().reference(withPath: "timesImages/\(docID)/brasaoTime.jpg").getData(maxSize: 1 * 4096 * 4096) { (data, err) in
            if let err = err {
                print("Error downloading image: \(err)")
            } else if let data = data {
                if let courtImage = UIImage(data: data) {
                    success(courtImage)
                }
            }
        }
    }
    
    static func getEventoImage(docID: String,
                              success: @escaping(UIImage)->(),
                              failure: @escaping()->()){
        Storage.storage().reference(withPath: "eventosImages/\(docID)/imgCapa.jpg").getData(maxSize: 1 * 4096 * 4096) { (data, err) in
            if let err = err {
                print("Error downloading image: \(err)")
            } else if let data = data {
                if let courtImage = UIImage(data: data) {
                    success(courtImage)
                }
            }
        }
    }
    
    static func getCourtImage(path: String,
                              success: @escaping(UIImage)->(),
                              failure: @escaping()->()){
        Storage.storage().reference(withPath: path).getData(maxSize: 1 * 4096 * 4096) { (data, err) in
            if let err = err {
                print("Error downloading image: \(err)")
            } else if let data = data {
                if let courtImage = UIImage(data: data) {
                    success(courtImage)
                }
            }
        }
    }
    
    static func getUserImage(number: String,
                              success: @escaping(UIImage)->(),
                              failure: @escaping()->()){
        Storage.storage().reference(withPath: "userImages/\(number)/profilePic.jpg").getData(maxSize: 1 * 4096 * 4096) { (data, err) in
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
    
    static func saveTimeImage(image: UIImage,
                              timeID: String,
                              success: @escaping(String)->(),
                              failure: @escaping()->()) {
        
        guard let photoData = image.jpegData(compressionQuality: 1.0) else { return }
        
        Storage.storage().reference(withPath: "timesImages/\(timeID)/profilePic.jpg").putData(photoData, metadata: nil) { metadata, error in
            
            guard let metadata = metadata, let path = metadata.path else {
                // Uh-oh, an error occurred!
                failure()
                return
            }
            
            success(path)
        }
    }
    
}
