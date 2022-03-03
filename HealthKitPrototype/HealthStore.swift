//
//  HealthStore.swift
//  HealthKitPrototype
//
//  Creates a singleton HKHealthStore? reference
//
//  Created by Joshua Rogers on 03/03/2022.
//

import Foundation
import HealthKit

class HealthStore {
    static let shared = HealthStore()
    
    private(set) var store: HKHealthStore?
    
    private init() {
        if HKHealthStore.isHealthDataAvailable() {
            store = HKHealthStore()
            
            let allTypes = Set([
                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!,
                HKObjectType.activitySummaryType()
            ])

            //Assert non-nil as we have the isHealthDataAvailable check above
            store!.requestAuthorization(toShare: nil, read: allTypes) {
                (success, error) in
                    if !success {
                        //If permissions are not obtained, act as if the
                        //store does not exist
                        self.store = nil
                    } else {
                        self.testQuery()
                    }
            }
        } else {
            store = nil
        }
    }
    
    func testQuery() {
        guard let activeEnergyType = HKSampleType.quantityType(
            forIdentifier: .activeEnergyBurned
        ) else {
            // This should never fail when using a defined constant.
            fatalError("*** Unable to get the active energy type ***")
        }
        
        let query = HKSampleQuery(
            sampleType: activeEnergyType,
            predicate: nil,
            limit: Int(HKObjectQueryNoLimit),
            sortDescriptors: nil
        ) {
            query, results, error in
            
            guard let samples = results as? [HKQuantitySample] else {
                // Handle any errors here.
                return
            }
            
            for sample in samples {
                print(sample)
                print()
            }
            
            // The results come back on an anonymous background queue.
            // Dispatch to the main queue before modifying the UI.
            
            DispatchQueue.main.async {
                // Update the UI here.
            }
        }
        
        store?.execute(query)
    }
}
