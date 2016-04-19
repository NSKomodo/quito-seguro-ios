//
//  TipsTableViewController.swift
//  Quito Seguro
//
//  Created by Jorge Tapia on 4/18/16.
//  Copyright © 2016 Prof Apps. All rights reserved.
//

import UIKit
import Firebase

let tipIdentifier = "TipCell"

class TipsTableViewController: UITableViewController {
    
    var data = [FDataSnapshot]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UI methods
    
    private func setupUI() {
        clearsSelectionOnViewWillAppear = false
        
        tableView.rowHeight = 88.0
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        // Setup refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = AppTheme.primaryDarkColor
        refreshControl?.tintColor = UIColor.whiteColor()
        refreshControl?.addTarget(self, action: #selector(StatsTableViewController.refresh), forControlEvents: .ValueChanged)
    }
    
    // MARK: - Data methods
    
    func refresh() {
        let reportsRef = Firebase(url: "\(AppUtils.firebaseAppURL)/tips")
        reportsRef.observeEventType(.Value, withBlock: { (snapshot) in
            self.data.removeAll()
            
            for child in snapshot.children.allObjects as! [FDataSnapshot] {
                self.data.append(child)
            }
            
            reportsRef.removeAllObservers()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        })
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! TipDetailTableViewController
        destinationViewController.tip = sender
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tipIdentifier, forIndexPath: indexPath)
        let locale = NSLocale.preferredLanguages().first
        let tip = data[indexPath.row].value
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = AppTheme.tableVieCellSelectionColor
        cell.selectedBackgroundView = selectedBackgroundView
        
        cell.textLabel?.font = AppTheme.defaultMediumFont?.fontWithSize(16.0)
        cell.textLabel?.textColor = AppTheme.redColor
        
        cell.detailTextLabel?.font = AppTheme.defaultFont?.fontWithSize(14.0)
        
        if locale!.containsString("es") {
            cell.textLabel?.text = tip["titleES"] as? String
            cell.detailTextLabel?.text = tip["summaryES"] as? String
        } else {
            cell.textLabel?.text = tip["titleEN"] as? String
            cell.detailTextLabel?.text = tip["summaryEN"] as? String
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if let url = NSURL(string: tip["thumbnail"] as! String) {
                if let data = NSData(contentsOfURL: url) {
                    dispatch_async(dispatch_get_main_queue()) {
                        if let updateCell = self.tableView.cellForRowAtIndexPath(indexPath) {
                            updateCell.imageView?.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tip = data[indexPath.row].value
        performSegueWithIdentifier("tipSegue", sender: tip)
    }

}
