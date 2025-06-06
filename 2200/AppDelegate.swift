//
//  AppDelegate.swift
//  2200
//
//  Created by Eduardo Borges Pinto Osório on 2/3/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//

import UIKit
import HealthKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var healthStore : HKHealthStore = HKHealthStore()

    var task : UIBackgroundTaskIdentifier?

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        self.task = application.beginBackgroundTask(withName: "StepWatcher") {
            print("boo") // FIX: why have this here?
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        guard let task = self.task else { return; }

        application.endBackgroundTask(task)
        self.task = UIBackgroundTaskIdentifier.invalid
    }
}
