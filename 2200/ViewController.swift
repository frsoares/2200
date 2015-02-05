//
//  ViewController.swift
//  2200
//
//  Created by Eduardo Borges Pinto Osório on 2/3/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//

var greenColor = UIColor(red: CGFloat(84.0/255.0), green: CGFloat(174.0/255.0), blue: CGFloat(58.0/255.0), alpha: CGFloat(1.0))

import UIKit

import HealthKit

class ViewController: UIViewController , CountDelegate {
  
    // Progress goes from 0.0 to 1.0
    var progress: Double = 0.0 {
      didSet{
        dispatch_async(dispatch_get_main_queue(), {
        
          self.progressView.progress =  CGFloat(self.progress) * 10.0
        
        }
        )
        
      }
    }
    
    var kgArray = [String]()
    
  
    var healthStore : HKHealthStore!// = HKHealthStore()
  
    var stepCounter : StepCounter?
    
    let defaultUserWeight = 65
    
    let maxUserWeight = 150
    
    var userWeight = 65
    
    // IBOutlets
  
    @IBOutlet weak var weightPicker: UIPickerView!
  
    @IBOutlet weak var lblGoal: UILabel!
    
    @IBOutlet weak var lblSteps: UILabel!
    
    @IBOutlet weak var progressView: ProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
        var ad = UIApplication.sharedApplication().delegate as AppDelegate
        healthStore = ad.healthStore;
        self.loadWeightArray()
//        self.selectUserWeight()
        self.stepCounter = StepCounter(healthStore: healthStore, delegate: self);
      
      healthStore.requestAuthorizationToShareTypes(nil, readTypes: dataTypesToRead(), completion: {
        (success:Bool, error:NSError!) -> Void in
        //      if !success{
        //        var alert = UIAlertView(title: "Missed authorization", message: "The app cannot work without authorization for HealthKit. Closing", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Close")
        //        alert.show();
        //        self.dismissViewControllerAnimated(true, completion: nil)
        
        //      }
        if success {
          
          println("Permission acquired")
          
          self.stepCounter!.initStepCount()
          
          self.stepCounter!.startObservingBackgroundChanges()
          
          self.selectUserWeight();
        }
        
      })
        
    }
  
    override func viewDidAppear(animated: Bool) {
      if let count = stepCounter?.stepCount {
        countUpdated(count)
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // weightPicker configuration
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!,
        numberOfRowsInComponent component: Int) -> Int {
            return kgArray.count
    }
    
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String {
        return kgArray[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView
    {
        var pickerLabel = UILabel()
        pickerLabel.textColor = greenColor
        pickerLabel.text = kgArray[row]
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "HelveticaNeue-Light", size: 30) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func selectedRowInComponent(component: Int) -> Int {
        var pos = -1
        var count = 0
        
        for (var i = defaultUserWeight; i <= maxUserWeight && pos == -1 ; i++, count++)
        {
            if (i == userWeight)
            {
                pos = count
            }
        }
        return pos
    }


  
    /*
     Method called every time the step counter is updated.
    */
    func countUpdated(newCount: Int) {
      
      dispatch_async(dispatch_get_main_queue(), {
        self.lblSteps.text = "\(newCount)"; self.lblSteps.setNeedsDisplay()
      })
      
      self.progress = Double(newCount) / 10000.0 // hardcoded at 10000 steps for testing while we don't have everything set up.
      
//      self.lblSteps.text = "\(newCount)"
    
    }
    
    func loadWeightArray() {
        for (var i = defaultUserWeight; i <= maxUserWeight; i++)
        {
            kgArray.append(String(i));
        }
    }
    
    func selectUserWeight() {
        let past : NSDate = NSDate.distantPast() as NSDate
        let now = NSDate()
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate: now, options: HKQueryOptions.None)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false);
        let idWeight = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        let sampleQuery = HKSampleQuery(sampleType: idWeight, predicate: mostRecentPredicate, limit: 0, sortDescriptors: [sortDescriptor], resultsHandler:
            {(_,results,_) -> Void in
                
                if (results != nil) {
                  if let sample : HKQuantitySample = results.first as? HKQuantitySample {
                    let quantity = sample.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo))
                    
                    dispatch_async(dispatch_get_main_queue(), {
                      self.userWeight = Int(quantity)
                      self.weightPicker.selectRow(self.selectedRowInComponent(0), inComponent: 0, animated: false)
                      
                    })
                  }
                }
        })
        
        healthStore.executeQuery(sampleQuery)
    }
  
  
  private func dataTypesToRead() -> NSSet {
    
    var typeIds = [HKQuantityTypeIdentifierHeight, HKQuantityTypeIdentifierBodyMass, HKQuantityTypeIdentifierDistanceWalkingRunning]
    
    
    var typeBodyMass = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
    //    var type2 = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
    //    var type3 = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
    var typeStepCount = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
    
    return NSSet(objects: typeStepCount, typeBodyMass)
    
  }
}

