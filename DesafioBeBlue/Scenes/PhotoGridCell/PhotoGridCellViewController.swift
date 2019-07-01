//
//  PhotoGridCell.swift
//  DesafioBeBlue
//
//  Created by Ricardo S. Barros on 29/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import UIKit
import Foundation

protocol PhotoGridCellDisplayLogic: class
{
    func displayDownloadedPhotos(photoDownloaded: UIImage?)
}

class PhotoGridCellViewController: UICollectionViewCell, PhotoGridCellDisplayLogic {

    @IBOutlet weak var imageView: UIImageView!
    var interactor: PhotoGridCellBusinessLogic?
    var satelliteName:String = ""
    var indexPath:Int = 0
    var photoInfo:Photo? = nil
    public var myParent:PhotoGridViewController? = nil
    var displayedPhotos : [Photo]?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup()
    {
        let viewController = self
        let interactor = PhotoGridCellInteractor()
        let presenter = PhotoGridCellPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    func setupCell(photo: Photo) {
        
        print(photo.photoImage)
        photoInfo = photo
        downloadImage(photoUrlToDownload: photo.photoImage)
    }
    
    func downloadImage(photoUrlToDownload:String) -> Void {
        
        let request = PhotoGridCell.FetchPhotos.Request (
            photoUrlToDownload: photoUrlToDownload,
            satelliteName: self.satelliteName
        )
        interactor?.downloadPhotos(request: request)
    }
    
    func setSatellite(selected:String) {
        self.satelliteName = selected
    }
    
    func setIndexPath(index:Int) {
        self.indexPath = index
    }

    func displayDownloadedPhotos(photoDownloaded: UIImage?) {
        self.imageView.image = photoDownloaded
    }
    
    @IBAction func touch_nasaPhoto(_ sender: Any) {
        if(myParent != nil){
            photoInfo?.photoImageDownloaded = imageView.image
            myParent!.openPhotoDetail(photo: photoInfo!)
        }
    }
    
}
