//
//  HistoryTableViewController.swift
//  2200
//
//  Created by Eduardo Borges Pinto Osório on 2/5/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//

import UIKit

import HealthKit

var items: [(date: String, steps: String)] = [] //[("27/01/15" , "4500 Steps"), ("28/01/15" , "4500 Steps"), ("29/01/15", "4500 Steps")]


class HistoryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var historyTable: UITableView!
    
  
    var healthStore : HKHealthStore!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      
      
//        UIApplication.sharedApplication().delegate
      
      var ad = UIApplication.sharedApplication().delegate as AppDelegate
      healthStore = ad.healthStore;
      
      loadHistoryData();
    }

  func loadHistoryData(){
    
    let past = NSDate.distantPast() as NSDate
    
    let today = NSDate();
    

    let calendar = NSCalendar(identifier: NSGregorianCalendar)
    
    let teste = NSDateComponents()
    teste.day=2
    teste.month=2
    teste.year=2015
    teste.hour=0
    teste.minute=0
    teste.second=0
    
    let anchorDate = calendar?.dateFromComponents(teste);
    
    
    let type : HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
    
    let intervalComponents = NSDateComponents();
    
    intervalComponents.day = 1;
    
    let predicate = HKQuery.predicateForSamplesWithStartDate(past, endDate: today, options: HKQueryOptions.StrictStartDate)
    
    let query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: predicate, options: HKStatisticsOptions.CumulativeSum, anchorDate: anchorDate, intervalComponents: intervalComponents)
    
    query.initialResultsHandler = {(query, results, error) -> Void in
      
      if let realResults = results {
      
        let statList = realResults.statistics()
        
        var unit = HKUnit(fromString: "count");
        
        for i : HKStatistics in statList as [HKStatistics] {
          
          if let quantity = i.sumQuantity(){
            let value = Int(quantity.doubleValueForUnit(unit))
            let day = i.startDate;
            items += [("\(day)", "\(value)")]
          }
          
        }
        
      }
      
    }
    
    healthStore.executeQuery(query);
    
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
