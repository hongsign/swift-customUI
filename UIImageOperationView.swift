//
//  UIImageOperationView.swift
//  Dev
//
//  Created by YU HONG on 2016-12-08.
//  Copyright © 2016 homesoft. All rights reserved.
//

import Foundation
import UIKit

/*---------------------------------------------
It is to display the image with parts. The parts
come from different style of one same image.

Designed for AngelaPet game that the origin image
will be a cute animal, and replacement image will
be a cute animal with clothes (hat, scarf , coat).

Usage: 
1) initialize() view rect and image
2) addZoneOnly() set zone rects
3) initializeZones() set image parts and views 
    according to initial zones and content tyeps
4) drawRect() setup imageviews of zones, and show up

afterwards:
addZone removeZone updateZone will caused redraw
of view
----------------------------------------------*/
class UIImageOperationView: UIView {
    /*-----------------------------------
    For each image part, what is the content
    to be used
    ------------------------------------*/
    enum ImageContentType: String {
        case origin
        case replace
    }
    
    /*-----------------------------------
    Origin and replace images
    ------------------------------------*/
    var originimage: UIImage!
    var replaceimage: UIImage!
    
    /*-----------------------------------
    Image parts
    ------------------------------------*/
    var zones: [CGRect] = [CGRect]()
    var originimages: [UIImage] = [UIImage]()
    var replaceimages: [UIImage] = [UIImage]()
    var contenttypes: [ImageContentType] = [ImageContentType]()
   
    /*-----------------------------------
    Display parts
    ------------------------------------*/
    var imageviews: [UIImageView] = [UIImageView]()
    
    override func drawRect(rect: CGRect) {
        subviews.forEach({ $0.removeFromSuperview() })
        
        imageviews.removeAll()
        
        let count = zones.count
        
        for i in 0..<count {
            if contenttypes[i] == ImageContentType.origin {
                imageviews.append(UIImageView(image: originimages[i]))
            }
            else {
                imageviews.append(UIImageView(image: replaceimages[i]))
            }
            imageviews[i].frame = zones[i]
            
            addSubview(imageviews[i])
        }
        
    }
    
    func initialize(rect: CGRect, originimage: String, replaceimage: String) {
        self.frame = rect
        self.originimage = ResizeImage( UIImage(named: originimage)!, targetSize: frame.size)
        self.replaceimage = ResizeImage( UIImage(named: replaceimage)!, targetSize: frame.size)
        
        
    }
    
    func addZoneOnly(rect: CGRect) {
        zones.append(rect)
    }
    
    func initializeZones() {
        /*--------------------------------------------------------------
        ONLY zones are set up. All others parts are not set yet.
        ----------------------------------------------------------------*/
        let count = zones.count
        
        for i in 0..<count {
            originimages.append(originimage.getPartialImage(zones[i])!)
            replaceimages.append(replaceimage.getPartialImage(zones[i])!)
            contenttypes.append(.origin)
        }
    }
    /*
    func addZone(rect: CGRect, contenttype: ImageContentType) {
        zones.append(rect)
        originimages.append(originimage.getPartialImage(rect)!)
        replaceimages.append(replaceimage.getPartialImage(rect)!)
        contenttypes.append(contenttype)
        
        setNeedsDisplay()
    }
    */
    
    func updateZone(index: Int, contenttype: ImageContentType) {
        if index < zones.count {
            if contenttypes[index] != contenttype {
                contenttypes[index] = contenttype
                setNeedsDisplay()
            }

        }
    }
    
    func removeZone(index: Int) {
        zones.removeAtIndex(index)
        originimages.removeAtIndex(index)
        replaceimages.removeAtIndex(index)
        contenttypes.removeAtIndex(index)
        
        setNeedsDisplay()
    }
    
    func clearZones() {
        
        originimages.removeAll()
        replaceimages.removeAll()
        contenttypes.removeAll()
        
        initializeZones()
        
        setNeedsDisplay()
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

}
