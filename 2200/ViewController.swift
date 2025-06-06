//
//  ViewController.swift
//  2200
//
//  Created by Eduardo Borges Pinto Osório on 2/3/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//
// testes

var greenColor = UIColor(red: CGFloat(84.0/255.0), green: CGFloat(174.0/255.0), blue: CGFloat(58.0/255.0), alpha: CGFloat(1.0))

import UIKit

import HealthKit

class ViewController: UIViewController , CountDelegate {
    
    // Progress goes from 0.0 to 1.0
    var progress: Double = 0.0 {
        didSet{
            DispatchQueue.main.async {
                self.progressView.progress =  CGFloat(self.progress) * 10.0
            }
        }
    }
    
    var kgArray = [String]()
    
    
    var healthStore : HKHealthStore!
    
    var stepCounter : StepCounter?
    
    let defaultUserWeight = 65
    
    let maxUserWeight = 150
    
    var userWeight = 65
    
    // IBOutlets
    
    @IBOutlet weak var weightPicker: UIPickerView!
    
    @IBOutlet weak var lblGoal: UILabel!
    
    @IBOutlet weak var lblSteps: UILabel!
    
    @IBOutlet weak var progressView: ProgressView!
    
    @IBAction func blurStart(_ sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblGoal.text = "10000"
        
        let ad = UIApplication.shared.delegate as! AppDelegate
        healthStore = ad.healthStore;
        self.loadWeightArray()
        self.stepCounter = StepCounter(healthStore: healthStore, delegate: self);
        
        healthStore.requestAuthorization(
            toShare: dataTypesToWrite(),
            read: dataTypesToRead()
        )  {
            (success:Bool, error:Error?) -> Void in
            
            if success {
                
                print("Permission acquired")
                
                self.stepCounter!.initStepCount()
                
                self.stepCounter!.startObservingBackgroundChanges()
                
                self.selectUserWeight();
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let count = stepCounter?.stepCount {
            countUpdated(count)
        }
    }
    
    //: weightPicker configuration
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        let alertController = UIAlertController(title: "Confirmation", message: "Confirm weight change?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //restore current weight
            self.setWeightInUI(self.userWeight, animation:true)
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print(row)
            let newWeight = Int(self.kgArray[row])
            self.saveUserWeight(Double(newWeight!))
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
        }
    }
    
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView!,
                    numberOfRowsInComponent component: Int) -> Int {
        return kgArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String {
        return kgArray[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = greenColor
        pickerLabel.text = kgArray[row]
        pickerLabel.font = UIFont(name: "HelveticaNeue-Light", size: 30) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func selectedRowInComponent(_ component: Int) -> Int {
        var pos = -1
        var count = 0
        
        if defaultUserWeight <= maxUserWeight {
            for i in defaultUserWeight...maxUserWeight {
                if (i == userWeight)
                {
                    // achou a posição do peso
                    pos = count
                    break;
                }
                count = count + 1
            }
        }
        return pos
    }
    
    ///
    /// Method called every time the step counter is updated.
    ///
    func countUpdated(_ newCount: Int) {
        
        DispatchQueue.main.async(execute: {
            self.lblSteps.text = "\(newCount)"; self.lblSteps.setNeedsDisplay()
        })
        
        // hardcoded at 10000 steps for testing while we don't have everything set up.
        self.progress = Double(newCount) / 10000.0
    }
    
    func loadWeightArray() {
        if defaultUserWeight <= maxUserWeight {
            for i in defaultUserWeight...maxUserWeight {
                kgArray.append(String(i));
            }
        }
    }
    
    func selectUserWeight() {
        let past : Date = Date.distantPast as Date
        let now = Date()
        let mostRecentPredicate = HKQuery.predicateForSamples(
            withStart: past,
            end: now,
            options: HKQueryOptions()
        )
        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: false
        );
        let idWeight = HKObjectType.quantityType(forIdentifier: .bodyMass)
        let sampleQuery = HKSampleQuery(
            sampleType: idWeight!,
            predicate: mostRecentPredicate,
            limit: 0,
            sortDescriptors: [sortDescriptor]
        ) {(_,results,_) -> Void in
            
            if (results != nil) {
                if let sample : HKQuantitySample = results?.first as? HKQuantitySample {
                    let quantity = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                    
                    DispatchQueue.main.async {
                        self.setWeightInUI(Int(quantity))
                    }
                }
            }
        }
        healthStore.execute(sampleQuery)
    }
    
    func saveUserWeight(_ weight: Double) {
        let bmType = HKQuantityType.quantityType(forIdentifier: .bodyMass)
        let bmQuantity = HKQuantity(unit: .gram(), doubleValue:  weight * 1000 )
        let sample = HKQuantitySample(
            type: bmType!,
            quantity: bmQuantity,
            start: Date(),
            end: Date()
        )
        
        self.healthStore.save(sample, withCompletion: {
            (success, error) in
            if success {
                self.userWeight = Int(weight)
            }
        })
    }
    
    func setWeightInUI(_ weight:Int, animation: Bool = false) {
        self.userWeight = weight
        self.weightPicker.selectRow(self.selectedRowInComponent(weight), inComponent: 0, animated: animation)
    }
    
    fileprivate func dataTypesToRead() -> Set<HKObjectType> {
        let typeBodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass)
        let typeStepCount = HKObjectType.quantityType(forIdentifier: .stepCount)
        
        return [typeStepCount!, typeBodyMass!]
    }
    
    
    fileprivate func dataTypesToWrite() -> Set<HKSampleType> {
        let typeBodyMass = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        
        return [typeBodyMass!]
    }
}

