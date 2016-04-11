//
//  ReportsViewController.swift
//  Quito Seguro
//
//  Created by Jorge Tapia on 3/2/16.
//  Copyright © 2016 Prof Apps. All rights reserved.
//

import UIKit
import GoogleMaps

class ReportsViewController: UIViewController {
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var hasUserLocation = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupMap()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: AppTheme.defaultFont ?? UIFont.systemFontOfSize(17.0)], forState: .Normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: AppTheme.disabledColor], forState: .Disabled)
        
        populateMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func filterAction(sender: AnyObject) {
    
    }
    
    // MARK: - UI methods
    
    private func setupUI() {
        // Setup footprint tab bar item
        let tabBarItemImage = UIImage(named: "report")?.imageWithRenderingMode(.AlwaysOriginal)
        let reportTabBarItem = tabBarController?.tabBar.items?[2]
        
        reportTabBarItem?.selectedImage = tabBarItemImage
        reportTabBarItem?.image = tabBarItemImage
    }
    
    // MARK: - Map methods
    
    private func setupMap() {
        mapView.delegate = self
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.settings.indoorPicker = true
        mapView.animateToCameraPosition(GMSCameraPosition.cameraWithLatitude(AppUtils.quitoLocation.coordinate.latitude,
            longitude: AppUtils.quitoLocation.coordinate.longitude, zoom: 11.0))
    }
    
    private func populateMap() {
    
    }
    
}

extension ReportsViewController: GMSMapViewDelegate {

    func didTapMyLocationButtonForMapView(mapView: GMSMapView) -> Bool {
        if let myLocation = mapView.myLocation {
            mapView.animateToCameraPosition(GMSCameraPosition.cameraWithLatitude(myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude, zoom: 15.0))
        }
        
        return true
    }
    
}
