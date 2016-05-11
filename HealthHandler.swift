//
//  HealthHandler.swift
//  Daily Scale
//
//  Created by Michael Holler on 11/05/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import Foundation
import HealthKit

class HealthHandler {

    let healthKitStore:HKHealthStore = HKHealthStore()

    init() {
        // authorizeHealthKit()
    }

    func authorizeHealthKit() -> Bool {
 
        var isOK = true
        
        // If the store is not available (for instance, iPad) return an error and don't go on.
        if (HKHealthStore.isHealthDataAvailable()) {
    
            // Set the types you want to write to HK Store
            let shareTypes = Set(arrayLiteral:HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!)
            let readTypes = Set(arrayLiteral:HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!)     // BDUF!
 
            // Request HealthKit authorization
            healthKitStore.requestAuthorizationToShareTypes(shareTypes, readTypes:readTypes) {
                (success, error) -> Void in isOK = success  }
        } else {
          isOK = false
        }
            
        return isOK
    }
    
    func saveWeight(date:NSDate, weight:Double) {
    
        let type = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!
        let quantity = HKQuantity(unit: HKUnit.gramUnitWithMetricPrefix(.Kilo), doubleValue: weight)
        let sample = HKQuantitySample(type: type, quantity: quantity, startDate: date, endDate: date)
 
        healthKitStore.saveObject(sample) { success, error in
            if (error != nil) {
                print("Error saving")
            }
        }
    }
}