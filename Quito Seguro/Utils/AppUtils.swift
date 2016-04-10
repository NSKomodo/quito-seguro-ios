//
//  AppUtils.swift
//  Footprints
//
//  Created by Jorge Tapia on 10/30/15.
//  Copyright © 2015 Jorge Tapia. All rights reserved.
//

import UIKit

class AppUtils {
    
    static let googleApisKey = "AIzaSyDAONSyUyjaCSnnT32aZTQdN1CvPgQwUo0"
    static let appStoreURL = NSURL(string: "https://itunes.apple.com/us/app/id1058674366?ls=1&mt=8")!

    class func imageWithFillColor(color: UIColor, rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColor(context, CGColorGetComponents(color.CGColor))
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func formattedStringFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE MMMM d, yyyy"
        
        return dateFormatter.stringFromDate(date)
    }
    
}
