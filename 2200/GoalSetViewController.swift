//
//  GoalSetViewController.swift
//  2200
//
//  Created by Eduardo Borges Pinto Osório on 2/5/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//

import UIKit

class GoalSetViewController: UIViewController {

    @IBOutlet weak var goalPicker: UIPickerView!
    
    
    @IBAction func doneButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
  
    
    var kgArray = [String]()
    
    let defaultUserWeight = 65
    
    let maxUserWeight = 150
    
    var userGoal:Goal = Goal()
    
    var goalStore = GoalStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tempGoal = goalStore.getGoal() {
            println("Goal object retrieved")
            self.userGoal = tempGoal
        }
        self.loadWeightArray()
        setWeightInUI() 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
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
    
    func pickerView(pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int) {
            
 /*           let alertController = UIAlertController(title: "Confirmation", message: "Confirm weight change?", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                self.setWeightInUI(animation:true)
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in*/
                self.userGoal.weight = Int32(self.kgArray[row].toInt()!)
                self.goalStore.saveGoal(self.userGoal)
                
           /* }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                
            }*/
    }

    func selectedRowInComponent(component: Int) -> Int {
        var pos = -1
        var count = 0
        var weight = Int(self.userGoal.weight)
        
        for (var i = defaultUserWeight; i <= maxUserWeight && pos == -1 ; i++, count++)
        {
            if (i == weight)
            {
                pos = count
            }
        }
        
        println("\(pos)")
        return pos
    }
    
    func loadWeightArray() {
        for (var i = defaultUserWeight; i <= maxUserWeight; i++)
        {
            kgArray.append(String(i));
        }
    }

    
    func setWeightInUI(animation: Bool = false) {
        self.goalPicker.selectRow(self.selectedRowInComponent(Int(userGoal.weight)), inComponent: 0, animated: animation)
    }

}
