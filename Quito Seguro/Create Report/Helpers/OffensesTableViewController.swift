//
//  OffensesTableViewController.swift
//  Quito Seguro
//
//  Created by Jorge Tapia on 4/11/16.
//  Copyright © 2016 Prof Apps. All rights reserved.
//

import UIKit

let identifier = "OffenseCell"

class OffensesTableViewController: UITableViewController {
    
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    @IBOutlet weak var selectButton: UIBarButtonItem!
    
    var selectedIndexPath: NSIndexPath?
    let data = ["off_robbery", "off_violence", "off_express_kidnapping", "off_missing_person", "off_murder", "off_house_robbery", "off_store_robbery", "off_grand_theft_auto", "off_credit_card_cloning", "off_public_disorder"]

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
        // TODO: implement
    }
    
    // MARK: - UI methods
    
    private func setupUI() {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: AppTheme.defaultMediumFont ?? UIFont.boldSystemFontOfSize(20.0)]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        clearsSelectionOnViewWillAppear = false
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let offense = NSLocalizedString(data[indexPath.row], comment: "Offense Type")
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        cell.tintColor = UIColor.whiteColor()
        
        let cellBg = UIView()
        cellBg.backgroundColor = AppTheme.redColor
        cellBg.layer.masksToBounds = true
        cell.multipleSelectionBackgroundView = cellBg;
        
        cell.textLabel?.text = offense
        return cell
    }
    
    // MARK: Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectedIndexPath != nil {
            tableView.cellForRowAtIndexPath(selectedIndexPath!)?.accessoryType = UITableViewCellAccessoryType.None
            tableView.deselectRowAtIndexPath(selectedIndexPath!, animated: true)
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        selectedIndexPath = indexPath
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        selectButton.enabled = true
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell?.accessoryType = UITableViewCellAccessoryType.None
        
        selectedIndexPath = nil
        selectButton.enabled = false
    }

}
