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
  
  var anchor : Int = 0;
  
  var obQuery : HKObserverQuery?
  
  var start : NSDate;
  
  //  var predicate : NSPredicate?
  
  var stepCount : Int {
    didSet{
      self.delegate.countUpdated(stepCount)
    }
  }
  
  var delegate : CountDelegate;
  
  init(healthStore : HKHealthStore, delegate : CountDelegate){
    
    self.healthStore = healthStore
    

    let calendar = NSCalendar.currentCalendar()
    var comp = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: NSDate())
    
    comp.hour = 0
    comp.minute = 0
    
    self.start = calendar.dateFromComponents(comp)!;
    
//    self.start = NSDate(timeIntervalSinceNow: -24*60*60) // now - 1 day
    
    self.stepCount = 0;
    self.delegate = delegate;
    
  }
  
  
  
  func initStepCount(){
    
    //    let past : NSDate = NSDate.distantPast() as NSDate
    
    
    
    
    let yesterday = start; //NSDate(timeIntervalSinceNow: -24*60*60)
    
    
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false);
    
    let idSteps = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
    
    //    let statQuery = HKStatisticsQuery(quantityType: idSteps, quantitySamplePredicate: mostRecentPredicate, options: HKStatisticsOptions.CumulativeSum, completionHandler: {(_,statistics,_) -> Void in
    //      if (statistics != nil) {
    //
    //        if let quantity : HKQuantity! = statistics.sumQuantity(){
    //            if let q = quantity {
    //                var unit = HKUnit(fromString: "count")
    //                self.stepCount = Int(q.doubleValueForUnit(unit));
    //            }
    //        }
    //
    //      }
    //    })
    
    
    //        if let setUpQuery = self.obQuery {
    //          self.healthStore.stopQuery(setUpQuery);
    //          self.obQuery = nil;
    //        }
    //
    
    if let setUpQuery = self.obQuery {
      // skip;
    }
    else{
      self.obQuery = HKObserverQuery(sampleType: idSteps, predicate:nil, updateHandler: {(_, handler, _) -> Void in
        
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(yesterday, endDate: NSDate(), options: HKQueryOptions.StrictStartDate)
        
        //        dispatch_after(5*1000,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { self.initStepCount() });
        //        //            self.initStepCount();
        
        let anchorQuery = HKAnchoredObjectQuery(type: idSteps, predicate: mostRecentPredicate, anchor: self.anchor, limit: 0, completionHandler: {(_, results, newAnchor,_) -> Void in
          if (results != nil) {
            
            if(newAnchor > self.anchor){
            
              self.anchor = newAnchor
              
              var sum:Int = 0
              
              var unit = HKUnit(fromString: "count")
              
              for quantitySample : HKQuantitySample in results as [HKQuantitySample]! {
                var quantity = quantitySample.quantity
                sum += Int(quantity.doubleValueForUnit(unit))
              }
              
              self.stepCount += sum
              
              //        if let quantity : HKQuantity! = statistics.sumQuantity(){
              //            if let q = quantity {
              //                var unit = HKUnit(fromString: "count")
              //                self.stepCount = Int(q.doubleValueForUnit(unit));
              //            }
              //        }
              
              
            }
            
            
          }
        })
        self.healthStore.executeQuery(anchorQuery);
        //
        //    healthStore.executeQuery(statQuery);
        

        handler()
        
        /* For testing purposes */
//        dispatch_async(dispatch_get_main_queue(), {
//          
//          var alert  = UIAlertView(title: "Update", message: "Passos atualizados", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "ok" );
//          alert.show()
//          
//        });
        
        
      })
      
      
      
      
      self.healthStore.executeQuery(self.obQuery);
    }
    
    
    
  }
  
  func startObservingBackgroundChanges(){
    let idSteps = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
    
    self.healthStore.enableBackgroundDeliveryForType(idSteps, frequency: .Immediate, withCompletion: {(success, error) -> Void in
      
      if success {
        println("Enabled background delivery of steps increase")
        //                            self.healthStore.executeQuery(self.obQuery)
        
      }
      else{
        if let theError = error {
          print("Failed to enable background delivery of weight changes")
          println("Error = \(theError)")
        }
      }
    })
  }
  
  func stopObservingChanges(){
    healthStore.stopQuery(obQuery)
    
    healthStore.disableAllBackgroundDeliveryWithCompletion({(succeeded:Bool, error: NSError!) in
      if succeeded {
        println("Disabled background delivery of step count increase")
      }
      else{
        if let theError = error{
          println("Failed to disable background delivery of steps")
          println("Error = \(theError)")
        }
      }
    })
  }
  
}

protocol CountDelegate{
  
  func countUpdated(newCount:Int);
  
}
