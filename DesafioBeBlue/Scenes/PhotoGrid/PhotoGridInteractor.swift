//
//  PhotoGridInteractor.swift
//  DesafioBeBlue
//
//  Created by Ricardo S. Barros on 29/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoGridBusinessLogic
{
    func fetchMarsPhotos(request: PhotoGrid.FetchPhotos.Request)
}

protocol PhotoGridDataStore
{
    var photoInfo: Photo? { get }
}

class PhotoGridInteractor: PhotoGridBusinessLogic, PhotoGridDataStore
{
    var presenter: PhotoGridPresentationLogic?
    var photosWorker = PhotosWorker()
    var photoInfo: Photo? = nil
    
    
    func fetchMarsPhotos(request: PhotoGrid.FetchPhotos.Request)
    {
        // Aqui Interactor chama o Worker responsável por executar o trabalho requisitado.
        let photoList = photosWorker.fetchMarsPhotos(astromobileName: request.astromobileName,
                                                     earthdate: request.earthdate)
        
        // Empacoto a resposta do worker e envio para o Presenter.
        let response = PhotoGrid.FetchPhotos.Response(photos: photoList)
        self.presenter?.presentFetchedPhotos(response: response)
    }
}
