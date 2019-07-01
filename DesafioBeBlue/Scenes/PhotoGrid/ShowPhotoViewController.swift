//
//  ShowPhotoViewController.swift
//  DesafioBeBlue
//
//  Created by Ricardo S. Barros on 29/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

class ShowPhotoViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var labelCameraName: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    public var photoInfo: Photo? = nil
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        setupScrollZoom()
        showPhotoDetail()
    }
    
    func setupScrollZoom() {
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGest)
    }
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = photoImageView.frame.size.height / scale
        zoomRect.size.width  = photoImageView.frame.size.width  / scale
        let newCenter = photoImageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }

    func showPhotoDetail()
    {
        if let photodet = photoInfo {
            photoImageView.image = photodet.photoImageDownloaded
            labelCameraName.text = photodet.cameraShortName
        }
    }
    
    @IBAction func touch_cameraName(_ sender: Any) {
        var inputed = labelCameraName.text
        
        if(inputed == photoInfo!.cameraShortName) {
            inputed = photoInfo!.cameraFullname
        }
        else {
            inputed = photoInfo!.cameraShortName
        }
        
        labelCameraName.text = inputed
    }
}
