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
    
    var isInsideQuito = false
    var report = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupMap()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        validate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func sendAction(sender: AnyObject) {
        sendReport()
    }
    
    @IBAction func offenseAction(sender: AnyObject) {
    }
    
    @IBAction func dateAction(sender: AnyObject) {
    }
    
    // MARK: - UI methods
    
    private func setupUI() {
        mapView.layer.cornerRadius = 4.0
    }
    
    private func validate() {
        // TODO: compare to localized strings
        sendButton.enabled = offenseLabel.text != "What happened?" && dateLabel.text != "When did it happen?" && isInsideQuito
    }
    
    // MARK: - Map methods
    
    private func setupMap() {
        mapView.delegate = self
        mapView.myLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.indoorPicker = true
        
        mapView.animateToCameraPosition(GMSCameraPosition.cameraWithLatitude(AppUtils.quitoLocation.coordinate.latitude,
            longitude: AppUtils.quitoLocation.coordinate.longitude, zoom: 11.0))
        
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
        polyline.map = mapView
    }
    
    // MARK: - Firebase methods
    
    private func sendReport() {
        let reportsRef = Firebase(url: "\(AppUtils.firebaseAppURL)/reports")
        
        let newReportRef = reportsRef.childByAutoId()
        newReportRef.setValue(report, withCompletionBlock: { (error, ref) in
            if error != nil {
                // NOT SAVED
            } else {
                // SAVED
            }
        })
    }

}

extension CreateReportViewController: GMSMapViewDelegate {
    
    func mapView(mapView: GMSMapView, didChangeCameraPosition position: GMSCameraPosition) {
        let center = CGPoint(x: CGRectGetMidX(mapView.bounds), y: CGRectGetMidY(mapView.bounds))
        let coordinate = mapView.projection.coordinateForPoint(center)
        
        report["lat"] = coordinate.latitude
        report["lng"] = coordinate.longitude
        
        isInsideQuito = (coordinate.latitude < -0.0413704 &&  coordinate.latitude > -0.3610194) && (coordinate.longitude < -78.4078789 && coordinate.longitude > -78.5881530)
        
        validate()
    }
    
}
