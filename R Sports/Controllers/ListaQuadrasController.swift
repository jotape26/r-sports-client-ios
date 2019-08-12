//
//  ListaQuadrasController.swift
//  R Sports
//
//  Created by João Pedro Leite on 29/03/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit
import Presentr

class ListaQuadrasController: UIViewController{
    
    @IBOutlet weak var quadrasTable: UITableView!
    
    private let presenter: Presentr = {
        let width = ModalSize.fluid(percentage: 0.9)
        let height = ModalSize.fluid(percentage: 0.3)
        let center = ModalCenterPosition.topCenter
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVerticalFromTop
        customPresenter.dismissTransitionType = .coverVerticalFromTop
        customPresenter.roundCorners = true
        customPresenter.backgroundColor = .clear
        return customPresenter
    }()
    
    private let viewModel = QuadrasFiltrosViewModel()
    private var quadras = [QuadraDTO]()
    private var timer : Timer?
    private var error = false
    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = AppConstants.ColorConstants.defaultGreen
        refresh.attributedTitle = NSAttributedString(string: "Procurando quadras perto de você", attributes: [.foregroundColor : AppConstants.ColorConstants.defaultGreen])
        return refresh
    }()
    
    private lazy var filtersButton : UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(filtersButtonClick))
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quadrasTable.register(UINib(nibName: "QuadrasCell", bundle: nil), forCellReuseIdentifier: "QuadrasCell")
        quadrasTable.register(UINib(nibName: "NoQuadrasCell", bundle: nil), forCellReuseIdentifier: "NoQuadrasCell")
        refreshControl.addTarget(self, action: #selector(startPooling), for: .valueChanged)
        quadrasTable.refreshControl = refreshControl
        // Do any additional setup after loading the view.
        
        refreshControl.beginRefreshing()
        startPooling()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = filtersButton
    }
    
    @objc func filtersButtonClick() {
        
        let t = FiltrosQuadrasController.create(vm: viewModel, caller: self)
        
        customPresentViewController(presenter, viewController: t, animated: true)
    }
    
    func t() {
        self.refreshControl.beginRefreshing()
        if quadrasTable.contentOffset.y == 0 {
            UIView.animate(withDuration: 0.25) {
                self.quadrasTable.contentOffset = CGPoint(x: 0, y: -self.refreshControl.frame.size.height)
            }
        }
    }
    
    @objc func startPooling() {
        error = false
        self.quadrasTable.reloadData()
        t()
        if let location = SharedSession.shared.currentLocation {
            
            timer = Timer.scheduledTimer(timeInterval: 6,
                                         target: self,
                                         selector: #selector(stopPoolingWithError),
                                         userInfo: nil, repeats: false)
            
            FirebaseService.retrieveCourts(userLocation: location,
                                           maximumDistance: Double(viewModel.distancia),
                                           minimumRating: Double(viewModel.rating)) { (qDTO) in
                self.refreshControl.endRefreshing()
                self.timer?.invalidate()
                self.timer = nil
                
                if !self.quadras.contains(where: { (dto) -> Bool in
                    if qDTO.documentID == dto.documentID {
                        return true
                    }
                    return false
                }) {
                    self.quadras.append(qDTO)
                    self.quadras.sort(by: { $0.distance(to: location) > $1.distance(to: location) })
                    self.quadrasTable.reloadData()
                }
                
            }
        }
    }
    
    @objc func stopPoolingWithError() {
        self.refreshControl.endRefreshing()
        error = true
        self.quadrasTable.reloadData()
    }
    
    func stopPooling() {
        self.refreshControl.endRefreshing()
        self.quadrasTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? QuadraDetailController {
            
            guard let iPath = quadrasTable.indexPathForSelectedRow else { return }
            
            vc.selectedQuadra = quadras[iPath.row]
        }
    }
}

extension ListaQuadrasController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if error {
            return 1
        } else {
            return quadras.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if error {
            return tableView.dequeueReusableCell(withIdentifier: "NoQuadrasCell")!
        } else {
            let current = quadras[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuadrasCell") as! QuadrasCell
            cell.prepareForReuse()
            
            cell.lbNomeQuadra.text = current.nome
            cell.lbEnderecoQuadra.text = current.endereco
            
            cell.lbPrecoQuadra.text = current.preco?.toCurrency()
            
            cell.ratingQuadra.rating = Double(current.rating ?? 0)
            
            if var path = current.imagens?.first, let docID = current.documentID {
                path = "imagensQuadras/\(docID)/\(path)"
                cell.downloadImage(path: path)
            }
            
            let distanceMeasure = Measurement(value: current.distance.rounded(toPlaces: 2), unit: UnitLength.meters)
            cell.lbDistancia.text = MeasurementFormatter().string(for: distanceMeasure)

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ListaToDetailsSegue", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListaQuadrasController : FiltrosQuadrasDelegate {
    func filtrosDidChange() {
        self.stopPooling()
        self.quadras.removeAll()
        self.startPooling()
    }
    
    
}
