//
//  StepCounter.swift
//  2200
//
//  Created by Francisco Soares on 2/4/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//

import Foundation

import HealthKit

class StepCounter {
  
  var healthStore : HKHealthStore;
  
  var stepCount : Int {
    didSet{
      self.delegate.countUpdated(stepCount)
    }
  }
  
  var delegate : CountDelegate;
  
  init(healthStore : HKHealthStore, delegate : CountDelegate){
    
    self.healthStore = healthStore
    
    self.stepCount = 0;
    self.delegate = delegate
    
    healthStore.requestAuthorizationToShareTypes(nil, readTypes: dataTypesToRead(), completion: {
      (success:Bool, error:NSError!) -> Void in
//      if !success{
//        var alert = UIAlertView(title: "Missed authorization", message: "The app cannot work without authorization for HealthKit. Closing", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Close")
//        alert.show();
//        self.dismissViewControllerAnimated(true, completion: nil)
        
//      }
      if success {
        
        println("Permission acquired")
        
        self.initStepCount()
        
      }
    })
   
  }
  
  private func initStepCount(){
    
    let past : NSDate = NSDate.distantPast() as NSDate
    
    let yesterday = NSDate(timeIntervalSinceNow: -24*60*60)
    
    let now = NSDate()
    
    let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(yesterday, endDate: now, options: HKQueryOptions.StrictStartDate)
    
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false);
    
    let idSteps = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
    
    let statQuery = HKStatisticsQuery(quantityType: idSteps, quantitySamplePredicate: mostRecentPredicate, options: HKStatisticsOptions.CumulativeSum, completionHandler: {(_,statistics,_) -> Void in
      if (statistics != nil) {
        
        var source : HKSource = statistics.sources.first as HKSource
        println("Number of sources: \(statistics.sources.count)")
        if let quantity : HKQuantity! = statistics.sumQuantity(){
          self.stepCount = Int(quantity.doubleValueForUnit(HKUnit(fromString: "count")));
        }
        
      }
    })
    
    
    healthStore.executeQuery(statQuery);
  }
  
  
  private func dataTypesToRead() -> NSSet {
    
    var typeIds = [HKQuantityTypeIdentifierHeight, HKQuantityTypeIdentifierBodyMass, HKQuantityTypeIdentifierDistanceWalkingRunning]
    
    
//    var type1 = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
//    var type2 = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
//    var type3 = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
    var typeStepCount = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)

    return NSSet(objects: typeStepCount)
    
  }
  
  
}

protocol CountDelegate{
  
  func countUpdated(newCount:Int);
  
}
