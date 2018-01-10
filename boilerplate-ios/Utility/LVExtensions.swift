//
//  LVExtensions.swift
//  boilerplate
//
//  Created by Leo Vigna on 22/12/2017.
//  Copyright © 2017 Leo Vigna. All rights reserved.
//

import Foundation
import UIKit

//MARK: Extensions
extension String: Error {
    ///Adds length property to strings
    var length: Int {
        return characters.count
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    
}

extension UIImage {
    ///Resizes images proportionally to fit bounds
    func resizeToMax(maxWidth: CGFloat = 300.0, maxHeight: CGFloat = 400.0) -> UIImage? {
        var actualHeight = self.size.height;
        var actualWidth = self.size.width;
        var imgRatio = actualWidth/actualHeight;
        let maxRatio = maxWidth/maxHeight;
        
        if (actualHeight > maxHeight || actualWidth > maxWidth)
        {
            if(imgRatio < maxRatio)
            {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio)
            {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else
            {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let rect = CGRect.init(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size);
        self.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return img
    }
    
    ///Compresses image to JPEG data
    func compressToJpeg(compression: CGFloat = 0.5) -> Data {
        return UIImageJPEGRepresentation(self, compression)!;
    }
    
}

extension Dictionary {
    ///Update dictionary with values from other dictionary
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
