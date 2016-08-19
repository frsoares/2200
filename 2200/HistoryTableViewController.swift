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
  
    var form = DateFormatter();
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
  
      form.dateStyle=DateFormatter.Style.long
      form.timeStyle=DateFormatter.Style.none;
      
//        UIApplication.sharedApplication().delegate
      
      let ad = UIApplication.shared.delegate as! AppDelegate
      healthStore = ad.healthStore;
      
      loadHistoryData();
    }

  func loadHistoryData(){
    
    let past = Date.distantPast as Date
    
    let today = Date();
    
    
    let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) //NSCalendar.Identifier(rawValue: NSCalendarIdentifierGregorian))
    
    
    
    
    var teste = DateComponents()
    teste.day=2
    teste.month=2
    teste.year=2015
    teste.hour=0
    teste.minute=0
    teste.second=0
    
    let anchorDate = calendar?.date(from: teste);
    
    
    let type : HKQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
    
    var intervalComponents = DateComponents();
    
    intervalComponents.day = 1;
    
    let predicate = HKQuery.predicateForSamples(withStart: past, end: today, options: HKQueryOptions.strictStartDate)
    
    let query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: predicate, options: HKStatisticsOptions.cumulativeSum, anchorDate: anchorDate!, intervalComponents: intervalComponents)
    
    query.initialResultsHandler = {(query, results, error) -> Void in
      
      if let realResults = results {
      
        let statList = realResults.statistics()
        
        let unit = HKUnit(from: "count");
        
        for i : HKStatistics in statList as [HKStatistics] {
          
          if let quantity = i.sumQuantity(){
            let value = Int(quantity.doubleValue(for: unit))
            let day = i.startDate;
            items.append(("\(self.form.string(from: day))", "\(value)"))
          }
          
        }
        
        
        
        DispatchQueue.main.async {
            self.historyTable.reloadData();
        }
        
      }
      
    }
    
    healthStore.execute(query);
    
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "historyCell")
        cell.textLabel?.text = "\(items[(indexPath as NSIndexPath).row].1)"
        cell.detailTextLabel?.text = "\(items[(indexPath as NSIndexPath).row].0)"
        return cell
    }


}
