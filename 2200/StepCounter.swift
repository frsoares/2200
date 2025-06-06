//
//  StepCounter.swift
//  2200
//
//  Created by Francisco Soares on 2/4/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

class StepCounter {
  
  var healthStore : HKHealthStore;
  
  var anchor : HKQueryAnchor = HKQueryAnchor(fromValue: 0);
  
  var obQuery : HKObserverQuery?
  
  var start : Date;
  
  //  var predicate : NSPredicate?
  
  var stepCount : Int {
    didSet{
      self.delegate.countUpdated(stepCount)
    }
  }
  
  var delegate : CountDelegate;
  
  init(healthStore : HKHealthStore, delegate : CountDelegate){
    
    self.healthStore = healthStore
    

    let calendar = NSCalendar.current
    var comp = calendar.dateComponents([.day, .month, .year], from: Date())
    
    comp.hour = 0
    comp.minute = 0
    
    self.start = calendar.date(from: comp)!;
    
//    self.start = NSDate(timeIntervalSinceNow: -24*60*60) // now - 1 day
    
    self.stepCount = 0;
    self.delegate = delegate;
    
  }
  
  
  
  func initStepCount(){

    let yesterday = start;
    
    //let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false);
    
    let idSteps = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
    
    
    //if self.obQuery != nil {
      // skip;
    //}
    //else{
    if self.obQuery == nil {
      self.obQuery = HKObserverQuery(sampleType: idSteps!, predicate:nil, updateHandler: {(_, handler, _) -> Void in
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: yesterday, end: NSDate() as Date, options: HKQueryOptions.strictStartDate)
        
        let anchorQuery = HKAnchoredObjectQuery(type: idSteps!, predicate: mostRecentPredicate, anchor: self.anchor, limit: 0) { (_, results, _, newAnchor, _) in //, resultsHandler: {(_, results, newAnchor,_) -> Void in
          if (results != nil) {
            if let newAnchor = newAnchor {
                
                self.anchor = newAnchor
                
                var sum:Int = 0
                
                let unit = HKUnit(from: "count")
                
                for quantitySample : HKQuantitySample in results as! [HKQuantitySample] {
                    let quantity = quantitySample.quantity
                    sum = sum + Int(quantity.doubleValue(for: unit))
                }
                
                self.stepCount = self.stepCount + sum
                
            }
            
          }
        }
        //})
        self.healthStore.execute(anchorQuery);

        handler()
        
      })
      
      self.healthStore.execute(self.obQuery!);
    }
    
    
    
  }
  
  func startObservingBackgroundChanges(){
    let idSteps = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
    
    self.healthStore.enableBackgroundDelivery(for: idSteps!, frequency: .immediate, withCompletion: {(success, error) -> Void in
      
      if success {
        print("Enabled background delivery of steps increase")
        //                            self.healthStore.executeQuery(self.obQuery)
        
      }
      else{
        if let theError = error {
          print("Failed to enable background delivery of weight changes")
          print("Error = \(theError)")
        }
      }
    })
  }
  
  func stopObservingChanges(){
    healthStore.stop(obQuery!)
    
    healthStore.disableAllBackgroundDelivery(completion: {(succeeded:Bool, error: NSError!) in
      if succeeded {
        print("Disabled background delivery of step count increase")
      }
      else{
        if let theError = error{
          print("Failed to disable background delivery of steps")
          print("Error = \(theError)")
        }
      }
    } as! (Bool, Error?) -> Void)
  }
  
}

protocol CountDelegate{
  
  func countUpdated(_ newCount:Int);
  
}
