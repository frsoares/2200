//
//  HistoryTableViewController.swift
//  2200
//
//  Created by Eduardo Borges Pinto Osório on 2/5/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//

import UIKit

var items: [(date: String, steps: String)] = [("27/01/15" , "4500 Steps"), ("28/01/15" , "4500 Steps"), ("29/01/15", "4500 Steps")]


class HistoryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var historyTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//     MARK: - Table view data source

//    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "historyCell")
        cell.textLabel?.text = "\(items[indexPath.row].1)"
        cell.detailTextLabel?.text = "\(items[indexPath.row].0)"
        return cell
    }


}
