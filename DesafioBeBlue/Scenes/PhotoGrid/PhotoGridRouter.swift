//
//  PhotoGridRouter.swift
//  DesafioBeBlue
//
//  Created by Ricardo S. Barros on 29/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoGridRoutingLogic
{
    func routeToShowPhoto(segue: UIStoryboardSegue?, photoInfo:Photo?)
}

protocol PhotoGridDataPassing
{
    var dataStore: PhotoGridDataStore? { get }
}

class PhotoGridRouter: NSObject, PhotoGridRoutingLogic, PhotoGridDataPassing
{
    weak var viewController: PhotoGridViewController?
    var dataStore: PhotoGridDataStore?
    var photoInfo: Photo? = nil
    
    // MARK: Routing

    func routeToShowPhoto(segue: UIStoryboardSegue?, photoInfo:Photo?)
    {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: "ShowPhotoViewController") as! ShowPhotoViewController

        destinationVC.photoInfo = photoInfo
        navigateToShowPhoto(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToShowPhoto(source: PhotoGridViewController, destination: ShowPhotoViewController)
    {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToShowPhoto(source: Photo, destination: inout Photo)
    {
        //destination.photo = source
    }
}
