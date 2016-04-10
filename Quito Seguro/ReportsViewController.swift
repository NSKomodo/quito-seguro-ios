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
        setupMap()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        populateMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func filterAction(sender: AnyObject) {
    
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
