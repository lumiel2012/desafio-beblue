//
//  seviceNasaAPI.swift
//  DesafioBeBlue
//
//  Created by Ricardo S. Barros on 29/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation

public class ServiceNasaAPI {
    
    private let session : URLSession
    //Account Email: lumiel2012@bol.com.br
    //Account ID: 8b06ecac-f858-4664-b78a-b1c4e9ae5af4
    // 01 Keys - "bhA5lRDabnETRGaskjGMbhGn5UyNhcxizaMrQpRV"
    // 02 Keys - "k0hr9FuoDyNgzvj0jNevPo6HQidfsDaFihTxGelL"
    private let apiKey : String = "k0hr9FuoDyNgzvj0jNevPo6HQidfsDaFihTxGelL"

    private let queryBase: String = "https://api.nasa.gov/mars-photos/api/v1/rovers/%@/photos?earth_date=%@&api_key=%@"
    private var queryMounted: String = ""
    
    init(session:URLSession) {
        self.session = session
    }
    
    // Método que efetua o download da informação trazida pela URL
    public func downloadPhotosFromURL2(photoURL:String, completion: ((Data) -> (Void))?) -> Void {
        
        var downloadData: Data = Data()
        
        if let url = NSURL(string: photoURL)
        {
            let request = NSURLRequest(url: url as URL)
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main)
            {
                (response, data, error) -> Void in
                downloadData = data!
                completion!(downloadData)
            }
        }
    }
    
    // Método alternativo que efetua o download da informação trazida pela URL
    public func downloadPhotosFromURL(photoURL:String) -> Data?
    {
        var downloadedData: Data?
        var _continue = false
        
        if let url = URL(string: photoURL)
        {
            let task = session.dataTask(with: url) { (data:Data?, _ , error:Error?) in
                
                if error != nil {
                    downloadedData = nil
                } else {
                    downloadedData = data
                }
                
                _continue = true
                return
            }
            task.resume()
        } else {
            downloadedData = nil
            print(NSError(domain:"Query Incorreta", code: 400, userInfo: nil))
        }
        
        while(!_continue){
            usleep(1000)
        }
        
        return downloadedData
    }
    
    // Método que faz a consulta na API da nasa para obter as informações.
    func getDataPackage(astromobileName:String, earthDate:String) -> [Photo]? {
        
        var photolist:[Photo]? = nil
        var earthDateMutable = earthDate
        var _continue = false
        var _tryAgain = true
        var numberDay = 1
        
        repeat
        {
            usleep(1000)
            
            if(_tryAgain)
            {
                _tryAgain = false
                queryMounted = String(format: queryBase, astromobileName, earthDateMutable, self.apiKey)
                let photoLogs = "Procurando fotos da sonda: " + astromobileName + "[" + "\(earthDateMutable)" + "]"
                print(photoLogs)
                
                if let url = URL(string: queryMounted) {
                    let task = session.dataTask(with: url) { (data:Data?, _ , error:Error?) in
                    
                        if let error = error {
                            print(error)
                            photolist = nil
                            _continue = true
                            return
                        }
                        else if let data = data, let photoData = self.decodePhotos(todecode: data) {
                            photolist = photoData
                            
                            if(photolist == nil || photolist!.count == 0) {
                                
                                print("No Photos: " + earthDateMutable)
                                // Subtraio um dia na data recebida para retornar fotos anteriores.
                                let dateFormatter:DateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                dateFormatter.isLenient = true
                                
                                if let myDate = dateFormatter.date(from: earthDateMutable) {
                                    let dayComp = DateComponents(day: -1)
                                    let date = Calendar.current.date(byAdding: dayComp, to: myDate)
                                    earthDateMutable = dateFormatter.string(from: date!)
                                    _continue = false
                                    _tryAgain = true
                                    
                                    numberDay = numberDay + 1
                                }
                                else {
                                    print("error")
                                    numberDay = numberDay + 1
                                }
                            }
                            else
                            {
                                print("Found Photos date: " + "\(earthDateMutable)")
                                _continue = true
                            }
                        }
                        else {
                            photolist = nil
                            print(NSError(domain:"Unknown Error", code: 500, userInfo: nil))
                            _continue = true
                            numberDay = numberDay + 1
                        }
                    }
                    task.resume()
                }
            }
            
            if(numberDay > 5){
                break
            }
            
        } while(!_continue)
        
        return photolist
    }
    
    // Método que decodifica cada pacote JSON recebido e facilita a montagem da lista.
    func decodePhotos(todecode:Data) -> [Photo]? {
        var photos = [Photo]()
        
        do
        {
            let json = try JSONSerialization.jsonObject(with: todecode, options:.allowFragments) as? Dictionary<String,Any>
            if let photosData = json?["photos"] as? [[String: Any]]
            {
                // Loop por cada imagem recebida para decodificar e armazenar.
                for item in photosData {
                    photos.append(Photo(jsonReceived: item))
                }
            }
        } catch _ {
            return nil
        }
        
        /*
         */
        
        return photos
    }
}
