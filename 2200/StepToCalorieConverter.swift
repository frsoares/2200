//
//  StepToCalorieConverter.swift
//  2200
//
//  Created by Kiev Gama on 2/4/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//
import UIKit

class StepToCalorieConverter: NSObject {
    
    
    // 1 calorie for each 20 steps
    //http://www.livestrong.com/article/320124-how-many-calories-does-the-average-person-use-per-step/
    let stepToCaloriesFactor = 1.0/20;
    
    func getCaloriesLost(#forTotalSteps: Int) -> Double {
        
        return (stepToCaloriesFactor * Double(forTotalSteps))
    }
    
    // 7700 calories to burn 1 kg
    //http://health.ninemsn.com.au/menshealth/healthandfitness/8412125/how-to-burn-1000-calories-fast
    
    let caloriesToKiloFactor = 1.0/7700
    func getKilosLost(#forTotalSteps: Int) -> Double {
        var cals = Double(getCaloriesLost(forTotalSteps:forTotalSteps))
        
        return cals * caloriesToKiloFactor
    }
    
    func getDaysToLose(#desiredWeight: Int) -> Double {
        var stepsPerDay = 10000
        var kilos = getKilosLost(forTotalSteps: stepsPerDay)
        
        return Double(desiredWeight) / kilos
        
        
    }

   
}
