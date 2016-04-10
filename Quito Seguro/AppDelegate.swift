//
//  AppDelegate.swift
//  Quito Seguro
//
//  Created by Jorge Tapia on 3/2/16.
//  Copyright © 2016 Prof Apps. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        GMSServices.provideAPIKey(AppUtils.googleApisKey)
        AppTheme.apply()
        
        return true
    }

}

