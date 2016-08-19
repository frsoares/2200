//
//  ReminderViewController.swift
//  2200
//
//  Created by Eduardo Borges Pinto Osório on 2/5/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController {

    @IBAction func doneButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    @IBAction func toggleSwitch(_ sender: AnyObject) {
      
      if reminderSwitch.isOn {
      
        datePickerValueChanged(reminderSwitch);
        
      }
      else{
        
        UIApplication.shared.cancelAllLocalNotifications()
      
      }
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func datePickerAction(_ sender: AnyObject) {
      
      print("date picker called")
      
      
      if reminderSwitch.isOn{
        UIApplication.shared.cancelAllLocalNotifications();
        
        let selectedDate = datePicker.date;
        
        let note = UILocalNotification()
        
        note.alertBody = "Hey! Just to remind you of walking your 10000 steps today! Check out how much you've walked already!"
        note.fireDate = selectedDate;
        
        note.repeatInterval = NSCalendar.Unit.day //.CalendarUnitDay
        
        UIApplication.shared.scheduleLocalNotification(note);

      }
    }

    var hourArray = [String]()


    
    let defaultUserWeight = 65
    
    let maxUserWeight = 24
    
    var userWeight = 65
    
    override func viewDidLoad() {
        super.viewDidLoad()

      // Do any additional setup after loading the view.

       datePicker.datePickerMode = UIDatePickerMode.time;
      
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func datePickerValueChanged(_ sender:AnyObject){
    
    UIApplication.shared.cancelAllLocalNotifications();
    
    let selectedDate = datePicker.date;
    
    let note = UILocalNotification()
    
    note.alertBody = ""
    note.fireDate = selectedDate;
    
    note.repeatInterval = NSCalendar.Unit.day //.CalendarUnitDay
    
    UIApplication.shared.scheduleLocalNotification(note);
    
  }
  
  
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
