//
//  UIExtensions.swift
//  Dev
//
//  Created by YU HONG on 2016-12-07.
//  Copyright © 2016 homesoft. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    /* EXAMPLE
    if let imageURL = NSURL(string:"http://i.stack.imgur.com/Xs4RX.jpg"),
    data = NSData(contentsOfURL: imageURL),
    image = UIImage(data: data) {
    
    let topHalf = image.topHalf
    let bottomHalf = image.bottomHalf
    
    let topLeft = topHalf?.leftHalf
    let topRight = topHalf?.rightHalf
    let bottomLeft = bottomHalf?.leftHalf
    let bottomRight = bottomHalf?.rightHalf
    }
    */
    var topHalf: UIImage? {
        guard let image = CGImageCreateWithImageInRect(CGImage,
            CGRect(origin: CGPoint(x: 0, y: 0),
                size: CGSize(width: size.width, height: size.height/2)))
            else { return nil }
        return UIImage(CGImage: image, scale: 1, orientation: imageOrientation)
    }
    
    var bottomHalf: UIImage? {
        guard let image = CGImageCreateWithImageInRect(CGImage,
            CGRect(origin: CGPoint(x: 0,  y: CGFloat(Int(size.height)-Int(size.height/2))),
                size: CGSize(width: size.width, height: CGFloat(Int(size.height) - Int(size.height/2)))))
            else { return nil }
        return UIImage(CGImage:
            image, scale: 1, orientation: imageOrientation)
    }
    var leftHalf: UIImage? {
        guard let image = CGImageCreateWithImageInRect(CGImage,
            CGRect(origin: CGPoint(x: 0, y: 0),
                size: CGSize(width: size.width/2, height: size.height)))
            else { return nil }
        return UIImage(CGImage: image, scale: 1, orientation: imageOrientation)
    }
    var rightHalf: UIImage? {
        guard let image = CGImageCreateWithImageInRect(CGImage,
            CGRect(origin: CGPoint(x: CGFloat(Int(size.width)-Int((size.width/2))), y: 0),
                size: CGSize(width: CGFloat(Int(size.width)-Int((size.width/2))), height: size.height)))
            else { return nil }
        return UIImage(CGImage: image, scale: 1, orientation: imageOrientation)
    }
    
    func getPartialImage(rect: CGRect, scale: CGFloat?=1) -> UIImage? {
        
        let s = scale ?? 1
        
        guard let image = CGImageCreateWithImageInRect(CGImage,
            CGRect(origin: CGPoint(x: rect.origin.x, y: rect.origin.y), size: CGSize(width: rect.size.width, height: rect.size.height)))
            else { return nil }
        return UIImage(CGImage: image, scale: s, orientation: imageOrientation)
        
    }
    
    func resizableImageWithStretchingProperties(
        X X: CGFloat, width widthProportion: CGFloat,
        Y: CGFloat, height heightProportion: CGFloat) -> UIImage {
            
            let selfWidth = self.size.width
            let selfHeight = self.size.height
            
            // insets along width
            let leftCapInset = X*selfWidth*(1-widthProportion)
            let rightCapInset = (1-X)*selfWidth*(1-widthProportion)
            
            // insets along height
            let topCapInset = Y*selfHeight*(1-heightProportion)
            let bottomCapInset = (1-Y)*selfHeight*(1-heightProportion)
            
            return self.resizableImageWithCapInsets(
                UIEdgeInsets(top: topCapInset, left: leftCapInset,
                    bottom: bottomCapInset, right: rightCapInset),
                resizingMode: .Stretch)
    }
    
}