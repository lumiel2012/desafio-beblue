//
//  PhotoGridViewController.swift
//  DesafioBeBlue
//
//  Created by Ricardo S. Barros on 29/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoGridDisplayLogic: class
{
    func displayPhotos(viewModel: [Photo]?)
}

class PhotoGridViewController: UIViewController, PhotoGridDisplayLogic, UICollectionViewDataSource, UICollectionViewDelegate
{
    var interactor: PhotoGridBusinessLogic?
    var router: (NSObjectProtocol & PhotoGridRoutingLogic & PhotoGridDataPassing)?
    var displayedPhotos: [Photo]? = []
    
    @IBOutlet weak var segmentedFilter: UISegmentedControl!
    @IBOutlet weak var photoGridCollection: UICollectionView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    @IBOutlet weak var labelInformation: UILabel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup()
    {
        let viewController = self
        let interactor = PhotoGridInteractor()
        let presenter = PhotoGridPresenter()
        let router = PhotoGridRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Indico o datasource do componente collectionView
        // Depois invoco a rotina que busca as fotos da api da NASA.
        photoGridCollection.delegate = self
        photoGridCollection.dataSource = self
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateNowFormatted = formatter.string(from: date)
        fetchMarsPhotos(earth_date: dateNowFormatted)
    }
    
    func fetchMarsPhotos(earth_date:String)
    {
        activityMonitor.isHidden = false
        activityMonitor.startAnimating()
        
         DispatchQueue.global(qos: .default).async {
            let astromobileSelected = self.segmentedFilter.titleForSegment(at: self.segmentedFilter.selectedSegmentIndex)!
        
            // Aqui no contexto ViewController chama Interactor responsável por coordenar suas ações.
            let request = PhotoGrid.FetchPhotos.Request(astromobileName: astromobileSelected,
                                                    earthdate: earth_date)
            
            print("selected date: " + earth_date )
            self.interactor?.fetchMarsPhotos(request: request)
        }
    }
    
    func getSelectedDateInPicker() -> Date {
        return datePicker.date
    }
    
    func UpdateDateToQuery() -> String {
        let date = getSelectedDateInPicker()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateFormatted = formatter.string(from: date)
        
        return dateFormatted
    }
    
    func displayPhotos(viewModel: [Photo]?)
    {
        // Recebo a lista de fotos e dispara renderização da collection.
        displayedPhotos = viewModel
        
        DispatchQueue.main.async {
            
            self.activityMonitor.stopAnimating()
            self.activityMonitor.isHidden = true
            self.photoGridCollection.reloadData()
            
            let dateFormatter:DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.isLenient = true
            
            if let viewModelPhoto = viewModel {
                if(viewModelPhoto.count > 0) {
                    if let myDate = dateFormatter.date(from: viewModelPhoto[0].earthDate) {
                        
                        if(self.datePicker.date != myDate) {
                            self.datePicker.date = myDate
                        }
                    }
                }
            }
        }
    }
    
    func openPhotoDetail(photo: Photo) {
        router?.routeToShowPhoto(segue: nil, photoInfo: photo)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(displayedPhotos != nil) {
            return displayedPhotos!.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoGridCell", for: indexPath) as! PhotoGridCellViewController
        
        // Configuro cada uma das células com a foto obtida da API.
        collectionCell.myParent = self
        if(displayedPhotos!.count > 0) {
            collectionCell.setupCell(photo: displayedPhotos![indexPath.row])
        }
        return collectionCell
    }
    
    @IBAction func filterActivated(_ sender: Any) {
        
        // Se o astromóvel for trocado precisamos baixar as fotos dele...
        displayedPhotos!.removeAll()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateNowFormatted = formatter.string(from: date)
        self.fetchMarsPhotos(earth_date: dateNowFormatted)
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        
        print(datePicker.date)
        // Se a data for trocada precisamos baixar as fotos daquela data...
        displayedPhotos!.removeAll()
        let dateFormatted = UpdateDateToQuery()
        self.fetchMarsPhotos(earth_date: dateFormatted)
    }
    
}
