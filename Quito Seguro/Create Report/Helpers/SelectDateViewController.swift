//
//  SelectDateViewController.swift
//  Footprints
//
//  Created by Jorge Tapia on 11/13/15.
//  Copyright © 2015 Jorge Tapia. All rights reserved.
//

import UIKit

class SelectDateViewController: UIViewController {
    
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var calendarViewTopSpaceConstraint: NSLayoutConstraint!
    
    weak var delegate: CreateReportViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func dismissAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectAction(sender: AnyObject) {
        delegate?.report["date"] = AppUtils.formattedStringFromDate(datePicker.date)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UI methods
    
    private func setupUI() {
        if DeviceModel.iPhone5 {
            calendarViewTopSpaceConstraint.constant = 50.0
        } else if DeviceModel.iPhone6 {
            calendarViewTopSpaceConstraint.constant = 80.0
        } else if DeviceModel.iPhone6Plus {
            calendarViewTopSpaceConstraint.constant = 110.0
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: AppTheme.defaultMediumFont?.fontWithSize(18.0) ?? UIFont.boldSystemFontOfSize(18.0)]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

}
