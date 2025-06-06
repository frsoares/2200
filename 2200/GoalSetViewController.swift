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

    @IBAction func doneButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    var kgArray = [String]()

    let defaultUserWeight = 65

    let maxUserWeight = 150

    var userGoal:Goal = Goal()

    var goalStore = GoalStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let tempGoal = goalStore.getGoal() {
            print("Goal object retrieved")
            self.userGoal = tempGoal
        }
        self.loadWeightArray()
        setWeightInUI()
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

    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {

        /*           let alertController = UIAlertController(title: "Confirmation", message: "Confirm weight change?", preferredStyle: .Alert)

         let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
         self.setWeightInUI(animation:true)
         }
         alertController.addAction(cancelAction)

         let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in*/
        self.userGoal.weight = Int(self.kgArray[row])!
        self.goalStore.saveGoal(self.userGoal)

        /* }
         alertController.addAction(OKAction)

         self.presentViewController(alertController, animated: true) {

         }*/
    }

    func selectedRowInComponent(_ component: Int) -> Int {
        var pos = -1
        var count = 0
        let weight = self.userGoal.weight

        if defaultUserWeight <= maxUserWeight {
            for i in defaultUserWeight...maxUserWeight {
                if i == weight {
                    pos = count
                    break
                }
                count = count + 1
            }
        }
        return pos
    }

    func loadWeightArray() {
        if defaultUserWeight <= maxUserWeight{

            for i in defaultUserWeight...maxUserWeight {
                kgArray.append(String(i));
            }
        }
    }


    func setWeightInUI(_ animation: Bool = false) {
        self.goalPicker.selectRow(self.selectedRowInComponent(Int(userGoal.weight)), inComponent: 0, animated: animation)
    }

}
