//
//  ReportsViewController.swift
//  Quito Seguro
//
//  Created by Jorge Tapia on 3/2/16.
//  Copyright © 2016 Prof Apps. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class ReportsViewController: UIViewController {
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tutorialView: UIVisualEffectView!
    
    var offenseFilter: String!
    
    var locationManager = CLLocationManager()
    var hasUserLocation = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupMap()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.addObserver(self, forKeyPath: "myLocation", options: .New, context: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        populateMap(offenseFilter)
        
        if NSUserDefaults.standardUserDefaults().boolForKey("launchCreateNew") {
            presentCreateReportViewController()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ReportsViewController.presentCreateReportViewController), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.removeObserver(self, forKeyPath: "myLocation")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "myLocation" && object is GMSMapView {
            if !hasUserLocation {
                mapView.settings.myLocationButton = true
                hasUserLocation = true
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - UI methods
    
    private func setupUI() {
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // Setup footprint tab bar item
        let tabBarItemImage = UIImage(named: "report")?.imageWithRenderingMode(.AlwaysOriginal)
        let reportTabBarItem = tabBarController?.tabBar.items?[2]
        
        reportTabBarItem?.selectedImage = tabBarItemImage
        reportTabBarItem?.image = tabBarItemImage
        
        tutorialView.hidden = NSUserDefaults.standardUserDefaults().boolForKey("tutorialDismissed")
        tutorialView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ReportsViewController.dimissTutorial)))
    }
    
    func presentCreateReportViewController() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.boolForKey("launchCreateNew") {
            defaults.removeObjectForKey("launchCreateNew")
            defaults.synchronize()
            
            self.tabBarController?.selectedIndex = 2
        }
    }
    
    func dimissTutorial() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "tutorialDismissed")
        defaults.synchronize()
        
        tutorialView.hidden = true
    }
    
    // MARK: - Map methods
    
    private func setupMap() {
        mapView.delegate = self
        mapView.myLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.indoorPicker = true
        mapView.animateToCameraPosition(GMSCameraPosition.cameraWithLatitude(AppUtils.quitoLocation.coordinate.latitude,
            longitude: AppUtils.quitoLocation.coordinate.longitude, zoom: 11.0))
    }
    
    private func populateMap(offense: String!) {
        mapView.clear()
        let reportsRef = Firebase(url: "\(AppUtils.firebaseAppURL)/reports")
        
        if offenseFilter == nil {
            reportsRef.queryOrderedByChild("offense").observeEventType(.ChildAdded, withBlock: { snapshot in
                if let offense = snapshot.value["offense"] as? String, let date = snapshot.value["date"] as? String, let lat = snapshot.value["lat"] as? CLLocationDegrees, let lng = snapshot.value["lng"] as? CLLocationDegrees {
                    dispatch_async(dispatch_get_main_queue()) {
                        if !self.filterButton.enabled {
                            self.filterButton.enabled = true
                        }
                        
                        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: lng))
                        marker.title = NSLocalizedString(offense, comment: "Localizaed offense")
                        marker.snippet = date
                        marker.icon = UIImage(named: "pin_2")
                        marker.map = self.mapView
                    }
                }
            })
        } else {
            reportsRef.queryOrderedByChild("offense").queryEqualToValue(offenseFilter).observeEventType(.ChildAdded, withBlock: { snapshot in
                if let offense = snapshot.value["offense"] as? String, let date = snapshot.value["date"] as? String, let lat = snapshot.value["lat"] as? CLLocationDegrees, let lng = snapshot.value["lng"] as? CLLocationDegrees {
                    dispatch_async(dispatch_get_main_queue()) {
                        if !self.filterButton.enabled {
                            self.filterButton.enabled = true
                        }
                        
                        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: lng))
                        marker.title = NSLocalizedString(offense, comment: "Localizaed offense")
                        marker.snippet = date
                        marker.icon = UIImage(named: "pin_2")
                        marker.map = self.mapView
                    }
                }
            })
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        
        if segue.identifier == "selectOffenseFromReportSegue" {
            let destinationViewController = navigationController.topViewController as! OffensesTableViewController
            destinationViewController.delegate = self
        }
    }
    
}

extension ReportsViewController: GMSMapViewDelegate {
    
    func didTapMyLocationButtonForMapView(mapView: GMSMapView) -> Bool {
        if let myLocation = mapView.myLocation {
            mapView.animateToCameraPosition(GMSCameraPosition.cameraWithLatitude(myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude, zoom: 17.0))
        }
        
        return true
    }
    
}
