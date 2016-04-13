//
//  StatsTableViewController.swift
//  Quito Seguro
//
//  Created by Jorge Tapia on 4/11/16.
//  Copyright © 2016 Prof Apps. All rights reserved.
//

import UIKit
import Firebase

let statIdentifier = "StatCell"
let statTotalIdentifier = "StatTotalCell"

class StatsTableViewController: UITableViewController {
    
    let data = ["Total", "off_robbery", "off_violence", "off_express_kidnapping", "off_missing_person", "off_murder", "off_house_robbery", "off_store_robbery", "off_grand_theft_auto", "off_credit_card_cloning", "off_public_disorder"]
    var totals = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var sum = 0
    var needsUpdate = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UI methods
    
    private func setupUI() {
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier(statTotalIdentifier, forIndexPath: indexPath)
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(statIdentifier, forIndexPath: indexPath)
        }
        
        let offense = data[indexPath.row]
        cell.textLabel?.text = NSLocalizedString(offense, comment: "Localized offense")
        
        if indexPath.row == 0 {
            cell?.textLabel?.text = "TOTAL"
            cell?.detailTextLabel?.text = String(sum)
        }
        
        if needsUpdate && indexPath.row > 0 {
            let reportsRef = Firebase(url: "\(AppUtils.firebaseAppURL)/reports")
            reportsRef.queryOrderedByChild("offense").queryEqualToValue(offense).observeEventType(.Value, withBlock: { snapshot in
                self.totals[indexPath.row] = snapshot.children.allObjects.count
                self.sum += snapshot.children.allObjects.count
                
                dispatch_async(dispatch_get_main_queue()) {
                    cell.detailTextLabel?.text = String(self.totals[indexPath.row])
                    
                    if indexPath.row == self.data.count - 1 {
                        self.needsUpdate = false
                        self.tableView.reloadData()
                    }
                }
            })
        }
        
        return cell
    }

}
