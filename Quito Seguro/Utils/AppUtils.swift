//
//  AppUtils.swift
//  Footprints
//
//  Created by Jorge Tapia on 10/30/15.
//  Copyright © 2015 Jorge Tapia. All rights reserved.
//

import UIKit
import CoreLocation

class AppUtils {
    
    static let googleApisKey = "AIzaSyCuE9xymvYES2tQ-q86soYMtkPCFEgB3Sg"
    static let appStoreURL = NSURL(string: "https://itunes.apple.com/us/app/id612526515?mt=8")!
    
    static let quitoLocation = CLLocation(latitude: -0.2166667, longitude: -78.5166667)
    static let quitoHomeLocation = CLLocation(latitude: -0.190037, longitude: -78.483259)

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
