//
//  CreateReportViewController.swift
//  Quito Seguro
//
//  Created by Jorge Tapia on 4/11/16.
//  Copyright © 2016 Prof Apps. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class CreateReportViewController: UIViewController {

    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var offenseLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var pinImageView: UIImageView!
    
    var hasUserLocation = false
    var isInsideQuito = false
    var report = [String: AnyObject]()
    
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
        validate()
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
                let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
                
                if isValidCoordinate(myLocation.coordinate) {
                    mapView.animateToCameraPosition(GMSCameraPosition.cameraWithLatitude(myLocation.coordinate.latitude,
                        longitude: myLocation.coordinate.longitude, zoom: 17.0))
                }
                
                hasUserLocation = true
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func sendAction(sender: AnyObject) {
        sendReport()
    }
    
    // MARK: - UI methods
    
    private func setupUI() {
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        mapView.layer.cornerRadius = 4.0
    }
    
    private func validate() {
        if let offense = report["offense"] as? String {
            offenseLabel.text = NSLocalizedString(offense, comment: "Localized offense")
        }
        
        if let date = report["date"] as? Double {
            dateLabel.text = NSLocalizedString(AppUtils.formattedStringFromDate(date), comment: "Localized offense")
        }
        
        sendButton.enabled = report["offense"] != nil && report["date"] != nil && isInsideQuito
    }
    
    private func reset() {
        report = [String: AnyObject]()
        
        offenseLabel.text = "What happened?"
        dateLabel.text = "When did it happen?"
        
        setupMap()
    }
    
    // MARK: - Map methods
    
    private func setupMap() {
        mapView.delegate = self
        mapView.myLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.indoorPicker = true
        mapView.animateToCameraPosition(GMSCameraPosition.cameraWithLatitude(AppUtils.quitoLocation.coordinate.latitude,
            longitude: AppUtils.quitoLocation.coordinate.longitude, zoom: 11.0))
        mapView.clear()
        
        drawBounds()
    }
    
    private func drawBounds() {
        let path = GMSMutablePath()
        path.addCoordinate(CLLocationCoordinate2D(latitude: -0.0413704, longitude: -78.5881530))
        path.addCoordinate(CLLocationCoordinate2D(latitude: -0.3610194, longitude: -78.5881530))
        path.addCoordinate(CLLocationCoordinate2D(latitude: -0.3610194, longitude: -78.4078789))
        path.addCoordinate(CLLocationCoordinate2D(latitude: -0.0413704, longitude: -78.4078789))
        path.addCoordinate(CLLocationCoordinate2D(latitude: -0.0413704, longitude: -78.5881530))
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = AppTheme.redColor
        polyline.geodesic = true
        polyline.map = mapView
    }
    
    private func isValidCoordinate(coordinate: CLLocationCoordinate2D) -> Bool {
        return (coordinate.latitude < -0.0413704 &&  coordinate.latitude > -0.3610194) && (coordinate.longitude < -78.4078789 && coordinate.longitude > -78.5881530)
    }
    
    // MARK: - Firebase methods
    
    private func sendReport() {
        // TODO: allow report sending once per hour
        let reportsRef = Firebase(url: "\(AppUtils.firebaseAppURL)/reports")
        report["platform"] = "iOS"
        
        let newReportRef = reportsRef.childByAutoId()
        newReportRef.setValue(report, withCompletionBlock: { (error, ref) in
            if error != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    AppUtils.presentAlertController("Error", message: error.localizedDescription, presentingViewController: self, completion: nil)
                }
            } else {
                AppUtils.presentAlertController("Quito Seguro", message: NSLocalizedString("REPORT_SENT", comment: "Report sent message"), presentingViewController: self) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.reset()
                        self.validate()
                        self.tabBarController?.selectedIndex = 0
                    }
                }
            }
        })
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        
        if segue.identifier == "selectOffenseFromCreateSegue" {
            let destinationViewController = navigationController.topViewController as! OffensesTableViewController
            destinationViewController.delegate = self
        }
        
        if segue.identifier == "selectDateFromCreateSegue" {
            let destinationViewController = navigationController.topViewController as! SelectDateViewController
            destinationViewController.delegate = self
        }
    }

}

extension CreateReportViewController: GMSMapViewDelegate {
    
    func mapView(mapView: GMSMapView, didChangeCameraPosition position: GMSCameraPosition) {
        report["lat"] = position.target.latitude
        report["lng"] = position.target.longitude
        
        isInsideQuito = isValidCoordinate(CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude))
        
        validate()
    }
    
}
