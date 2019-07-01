//
//  PhotoGridPresenter.swift
//  DesafioBeBlue
//
//  Created by Ricardo S. Barros on 29/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoGridPresentationLogic
{
    func presentFetchedPhotos(response: PhotoGrid.FetchPhotos.Response)
}

class PhotoGridPresenter: PhotoGridPresentationLogic
{
    weak var viewController: PhotoGridDisplayLogic?
    
    func presentFetchedPhotos(response: PhotoGrid.FetchPhotos.Response)
    {
        // Aqui no contexto Presenter devolvendo a informação ao ViewController Ciclo VIP.
        let displayedPhoto = PhotoGrid.FetchPhotos.ViewModel.init(displayedPhotos: response.photos)
        viewController?.displayPhotos(viewModel: displayedPhoto.displayedPhotos)
    }
}
