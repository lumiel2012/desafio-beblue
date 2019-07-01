//
//  PhotoGridCellInteractor.swift
//  DesafioBeBlue
//
//  Created by Ricardo S. Barros on 29/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoGridCellBusinessLogic
{
    func downloadPhotos(request: PhotoGridCell.FetchPhotos.Request)
}

protocol PhotoGridCellDataStore
{
    var photos: [Photo]? { get }
}

class PhotoGridCellInteractor: PhotoGridCellBusinessLogic, PhotoGridCellDataStore
{
    var photos: [Photo]?
    var presenter: PhotoGridCellPresentationLogic?
    var photosWorker = PhotosWorker()
    
    func downloadPhotos(request: PhotoGridCell.FetchPhotos.Request)
    {
        photosWorker.downloadPhotos(photoUrlToDownload: request.photoUrlToDownload)
        { data in
            let response = PhotoGridCell.FetchPhotos.Response(data: data)
            self.presenter?.presentDownloadedPhotos(response: response)
        }
    }
}
