//
//  AboutTableViewController
//  Quito Seguro
//
//  Created by Jorge Tapia on 4/15/16.
//  Copyright © 2016 Jorge Tapia. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {
    
    @IBOutlet weak var deleteCell: UITableViewCell!
    @IBOutlet weak var deleteLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UI methods
    
    private func setupUI() {
        self.clearsSelectionOnViewWillAppear = true
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = AppTheme.tableVieCellSelectionColor
        
        for section in 0...tableView.numberOfSections - 1 {
            for row in 0...tableView.numberOfRowsInSection(section) - 1 {
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.selectedBackgroundView = selectedBackgroundView
            }
        }
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    
    private func presentCallAlertController(message: String, completion: () -> Void) {
        let alert = UIAlertController(title: "Quito Seguro", message: message, preferredStyle: .Alert)
        alert.view.tintColor = AppTheme.primaryColor
        
        let dismissAction = UIAlertAction(title: NSLocalizedString("DISMISS", comment: "Dismiss"), style: .Cancel, handler: nil)
        let callAction = UIAlertAction(title: NSLocalizedString("YES", comment: "Yes"), style: .Default) { (action) in
            completion()
        }
        
        alert.addAction(dismissAction)
        alert.addAction(callAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                presentCallAlertController(NSLocalizedString("CALL_911", comment: "Call 911")) {
                    UIApplication.sharedApplication().openURL(NSURL(string: "tel:911")!)
                }
            } else if indexPath.row == 1 {
                presentCallAlertController(NSLocalizedString("CALL_101", comment: "Call 101")) {
                    UIApplication.sharedApplication().openURL(NSURL(string: "tel:101")!)
                }
            } else if indexPath.row == 2 {
                presentCallAlertController(NSLocalizedString("CALL_102", comment: "Call 102")) {
                    UIApplication.sharedApplication().openURL(NSURL(string: "tel:102")!)
                }
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
