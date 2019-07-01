//
//  PhotosWorker.swift
//  DesafioBeBlue
//
//  Created by Ricardo S. Barros on 29/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

class PhotosWorker
{
    var serviceNasaAPI:ServiceNasaAPI? = nil
    var imageTask:URLSessionDataTask?
    
    // Método que faz o download da foto disponibilizada pela API da NASA, funciona através do padrão
    // de delegates que se autosinalizam quando terminam seu trabalho.
    func downloadPhotos(photoUrlToDownload:String, completion: ((Data) -> (Void))?) -> Void {
    
        serviceNasaAPI = ServiceNasaAPI(session: URLSession.shared)
        if let imageTask = imageTask { imageTask.cancel() }
        
        self.serviceNasaAPI?.downloadPhotosFromURL2(photoURL: photoUrlToDownload) { data in
            completion!(data)
        }
    }
    
    // Método que faz a requisição do conjunto de fotos do astromóvel selecionado.
    func fetchMarsPhotos(astromobileName:String, earthdate:String) -> [Photo]?
    {
        var photoList: [Photo]? = nil
        
        serviceNasaAPI = ServiceNasaAPI(session: URLSession.shared)
        photoList = serviceNasaAPI?.getDataPackage(astromobileName: astromobileName, earthDate: earthdate)
        
        return photoList
    }
}
