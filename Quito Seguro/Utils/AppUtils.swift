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
    
    static let firebaseAppURL = "https://quito-seguro.firebaseio.com"
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
    
    class func numberOfLinesForText(text: NSString, labelWidth: CGFloat, font: UIFont) -> Int {
        let maxSize = CGSize(width: labelWidth, height: CGFloat(FLT_MAX))
        let rect = text.boundingRectWithSize(maxSize, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return Int(ceil(rect.size.height / font.lineHeight))
    }
    
    class func formattedStringFromDate(timeInterval: NSTimeInterval) -> String {
        let date = NSDate(timeIntervalSince1970: timeInterval / 1000)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM d, yyyy"
        
        return dateFormatter.stringFromDate(date)
    }
    
    class func presentAlertController(title: String?, message: String?, presentingViewController: UIViewController, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = AppTheme.primaryColor
        
        let dismissAction = UIAlertAction(title: NSLocalizedString("DISMISS", comment: "Dismiss"), style: .Default, handler: { action in
            completion?()
        })
        
        alert.addAction(dismissAction)
        presentingViewController.presentViewController(alert, animated: true, completion: nil)
    }
    
}
