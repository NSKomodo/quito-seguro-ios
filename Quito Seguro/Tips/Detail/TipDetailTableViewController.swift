//
//  TipDetailTableViewController.swift
//  Quito Seguro
//
//  Created by Jorge Tapia on 4/19/16.
//  Copyright © 2016 Prof Apps. All rights reserved.
//

import UIKit

class TipDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var tip: AnyObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func shareAction(sender: AnyObject) {
    }
    
    // MARK: UI methods
    
    private func setupUI() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if let url = NSURL(string: self.tip["header"] as! String) {
                if let data = NSData(contentsOfURL: url) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.imageView?.image = UIImage(data: data)
                    }
                }
            }
        }
        
        let locale = NSLocale.preferredLanguages().first
        
        if locale!.containsString("es") {
            title = tip["titleES"] as? String
            label.text = (tip["textES"] as? String)?.stringByReplacingOccurrencesOfString("###", withString: "\n\n")
        } else {
            title = tip["titleEN"] as? String
            label.text = (tip["textEN"] as? String)?.stringByReplacingOccurrencesOfString("###", withString: "\n\n")
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view delegate
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            AppUtils.presentAlertController("Share", message: "Share \"\(title!)\"?", presentingViewController: self) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UIScreen.mainScreen().bounds.size.width / 2
        } else if indexPath.section == 1 {
            return CGFloat(AppUtils.numberOfLinesForText(label.text!, labelWidth: UIScreen.mainScreen().bounds.width - 32, font: AppTheme.defaultFont!)) * 22.0
        } else {
            return 44.0
        }
    }

}
