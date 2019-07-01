//
//  PhotoGridPresenter.swift
//  DesafioBeBlue
//
//  Created by Ricardo S. Barros on 29/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import Foundation
import UIKit

protocol PhotoGridCellPresentationLogic
{
    func presentDownloadedPhotos(response: PhotoGridCell.FetchPhotos.Response)
}

class PhotoGridCellPresenter: PhotoGridCellPresentationLogic
{
    weak var viewController: PhotoGridCellDisplayLogic?
    
    // MARK: - Fetch Photos
    
    func presentDownloadedPhotos(response: PhotoGridCell.FetchPhotos.Response)
    {
        var downloadPhoto:UIImage? = nil
        if let dataExtracted = response.data {
            downloadPhoto = UIImage(data: dataExtracted)
        }
        viewController?.displayDownloadedPhotos(photoDownloaded: downloadPhoto)
    }
}
