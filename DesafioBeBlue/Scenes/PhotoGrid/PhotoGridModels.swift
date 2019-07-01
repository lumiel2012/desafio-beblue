//
//  PhotoGridModels.swift
//  DesafioBeBlue
//
//  Created by Ricardo S. Barros on 29/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

enum PhotoGrid
{
    // MARK: Use cases
    
    enum FetchPhotos
    {
        struct Request
        {
            var astromobileName:String
            var earthdate:String
        }
        struct Response
        {
            var photos: [Photo]?
        }
        struct ViewModel
        {
            public var displayedPhotos: [Photo]?
        }
    }
}
