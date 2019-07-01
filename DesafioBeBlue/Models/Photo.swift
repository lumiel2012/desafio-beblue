//
//  Photo.swift
//  DesafioBeBlue
//
//  Created by Ricardo S. Barros on 29/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

struct Photo: Equatable
{
    var photoId: String = ""
    var cameraShortName: String = ""
    var cameraFullname: String = ""
    var photoImage:String = ""
    var earthDate:String = ""
    var photoImageDownloaded:UIImage? = nil
    
    init(jsonReceived: [String: Any]) {
        self.decodePhotoParameter(jsonReceived: jsonReceived)
        self.decodeCameraParameter(jsonReceived: jsonReceived)
    }
    
    init(download: UIImage?) {
        self.photoImageDownloaded = download
    }
    
    mutating func decodePhotoParameter(jsonReceived: [String: Any]) {
        photoId = jsonReceived["id"] as? String ?? ""
        photoImage = jsonReceived["img_src"] as? String ?? ""
        earthDate = jsonReceived["earth_date"] as? String ?? ""
    }
    
    mutating func decodeCameraParameter(jsonReceived: [String: Any]) {
        if let cameraJson = jsonReceived["camera"] as? [String:Any]
        {
            cameraShortName = cameraJson["name"] as? String ?? ""
            cameraFullname = cameraJson["full_name"] as? String ?? ""
        }
        else
        {
            cameraShortName = ""
            cameraFullname = ""
        }
    }
}
