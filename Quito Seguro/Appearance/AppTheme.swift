//
//  AppTheme.swift
//  Footprints
//
//  Created by Jorge Tapia on 3/24/16.
//  Copyright © 2016 Jorge Tapia. All rights reserved.
//

import UIKit

class AppTheme {
    
    static let darkGrayColor = UIColor(red: 28.0 / 255.0, green: 28.0 / 255.0, blue: 28.0 / 255.0, alpha: 1.0)
    static let primaryColor = UIColor(red: 68.0 / 255.0, green: 63.0 / 255.0, blue: 70.0 / 255.0, alpha: 1.0)
    static let primaryDarkColor = UIColor(red: 17.0 / 255.0, green: 16.0 / 255.0, blue: 29.0 / 255.0, alpha: 1.0)
    static let disabledColor = UIColor(red: 99.0 / 255.0, green: 99 / 255.0, blue: 99 / 255.0, alpha: 1.0)
    static let redColor = UIColor(red: 244.0 / 255.0, green: 67.0 / 255.0, blue: 54.0 / 255.0, alpha: 1.0)
    static let tableVieCellSelectionColor = UIColor(red: 102.0 / 255.0, green: 102.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
    
    static let headingFont = UIFont(name: "AppleSDGothicNeo-ExtraBold", size: 22.0)
    static let defaultFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 17.0)
    static let defaultMediumFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 17.0)
    static let defaultBoldFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 17.0)
    
    class func apply() {
        // Customizes navigation bars
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = primaryColor
        UINavigationBar.appearance().barStyle = .Black
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: defaultMediumFont ?? UIFont.boldSystemFontOfSize(20.0)]
        
        // Customizes tab bars
        UITabBar.appearance().translucent = false
        UITabBar.appearance().barTintColor = primaryDarkColor
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        let tabBarItemRect = CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width / 5.0, height: 49.0)
        UITabBar.appearance().selectionIndicatorImage = AppUtils.imageWithFillColor(UIColor.blackColor(), rect: tabBarItemRect)
        
        // Customizes labels
        UILabel.appearance().font = defaultFont
        UILabel.appearanceWhenContainedInInstancesOfClasses([UITextField.self]).font = defaultFont?.fontWithSize(14.0)
        
        // Customizes text fields
        UITextField.appearance().font = defaultFont?.fontWithSize(14.0)
        UITextField.appearance().keyboardAppearance = .Dark
        
        // Customizes text views
        UITextView.appearance().font = defaultFont
        
        // Customizes search bars
        UISearchBar.appearance().barTintColor = primaryColor
        UISearchBar.appearance().barStyle = .Black
        UISearchBar.appearance().translucent = false
        UISearchBar.appearance().keyboardAppearance = .Dark
        
        UIDatePicker.appearance().tintColor = primaryColor
    }
    
}
