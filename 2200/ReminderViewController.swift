//
//  ReminderViewController.swift
//  2200
//
//  Created by Eduardo Borges Pinto Osório on 2/5/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//

import UIKit
import UserNotifications

class ReminderViewController: UIViewController {

    @IBAction func doneButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    @IBAction func toggleSwitch(_ sender: AnyObject) {
      
      if reminderSwitch.isOn {
      
        datePickerAction(reminderSwitch);
        
      }
      else{
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
      
      }
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func datePickerAction(_ sender: AnyObject) {
      
      print("date picker called")
      
      
      if reminderSwitch.isOn{
        
        // código para enviar uma notificação local
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let selectedDate = datePicker.date;
        
        let content = UNMutableNotificationContent()
        
        content.body = "Hey! Just to remind you of walking your 10000 steps today! Check out how much you've walked already!"
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: selectedDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)

        // fim do código de notificação
        
      }
    }

    
    
    var hourArray = [String]()


    
    let defaultUserWeight = 65
    
    let maxUserWeight = 24
    
    var userWeight = 65
    
    override func viewDidLoad() {
        super.viewDidLoad()


       datePicker.datePickerMode = UIDatePickerMode.time;
      
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  

}
