//
//  PhotoGridModels.swift
//  DesafioBeBlue
//
//  Created by Ricardo S. Barros on 29/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

enum PhotoGridCell
{
    // MARK: Use cases
    
    enum FetchPhotos
    {
        struct Request
        {
            var photoUrlToDownload:String
            var satelliteName:String
        }
        struct Response
        {
            var data: Data?
        }
        struct ViewModel
        {
            var displayedPhotos: [Photo]?
        }
    }
}
