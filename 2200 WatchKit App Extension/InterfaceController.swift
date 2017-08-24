//
//  InterfaceController.swift
//  2200 WatchKit App Extension
//
//  Created by Francisco Soares on 8/19/16.
//  Copyright © 2016 Eduardo Borges Pinto Osório. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications

class InterfaceController: WKInterfaceController {

    @IBOutlet var mapa: WKInterfaceMap!
    
    
    let location = CLLocationCoordinate2D(latitude: -8.052134, longitude: -34.960628)
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
   
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: location, span:span)
        
        self.mapa.setRegion(region)
        
        self.mapa.addAnnotation(location, with: .green)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    

}
