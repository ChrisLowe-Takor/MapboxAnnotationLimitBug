//
//  ViewController.swift
//  MapboxAnnotationBug
//
//  Created by Christopher Lowe on 7/01/2016.
//  Copyright © 2016 Takor Group. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView?
    let postMarkerImage = UIImage(named: "post_marker")!
    
    
    func annotationUIImageForNumberedMarker(number: Int) -> UIImage {
        
        let size = postMarkerImage.size
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        postMarkerImage.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        let drawRect = CGRectMake(18, 18, 42, 42)
        let text: NSString = "\(number)"
        let textAttributes = [NSFontAttributeName: UIFont(name: "Helvetica Bold", size: 16)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        text.drawInRect(drawRect, withAttributes: textAttributes)
        
        let markerAnnotationImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return markerAnnotationImage
    }
    

    
    func annotationCGImageForNumberedMarker(number: Int) -> UIImage {
        
        let rect = CGRectMake(0, 0, 42, 42)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGBitmapContextCreate(nil, 42, 42, 8, 0, colorSpace, CGImageAlphaInfo.PremultipliedFirst.rawValue)

        CGContextDrawImage(context, rect, postMarkerImage.CGImage)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor);
        CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor);
        
        let text: NSString = "\(number)"
        let textAttributes = [NSFontAttributeName: UIFont(name: "Helvetica Bold", size: 16)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        let cfText = CFAttributedStringCreate(nil, text, textAttributes)
        let line = CTLineCreateWithAttributedString(cfText)
        
        CGContextSetLineWidth(context, 1.0)
        CGContextSetTextDrawingMode(context, CGTextDrawingMode.Fill)
        CGContextSetTextPosition(context, 14, 18)
        CTLineDraw(line, context!)
        
        let cgImage = CGBitmapContextCreateImage(context)!
        return UIImage(CGImage: cgImage)
    }
    
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        let number = Int(annotation.title!!)!
        let annotationImage = annotationCGImageForNumberedMarker(number)
        return MGLAnnotationImage(image: annotationImage, reuseIdentifier: "\(number)")
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    
    func createTestAnnotations() {
        var annotations = [MGLPointAnnotation]()
        var count = 0
        for idxX in 0...19 {
            for idxY in 0...19 {
                count++
                let coordinate = CLLocationCoordinate2DMake(Double(idxX), Double(idxY))
                let annotation = MGLPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(count)"
                annotations.append(annotation)
            }
        }
        
        mapView?.addAnnotations(annotations)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MGLMapView(frame: view.bounds)
        mapView?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView?.delegate = self
        view.addSubview(mapView!)
    }
    
    override func viewDidAppear(animated: Bool) {
        createTestAnnotations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

