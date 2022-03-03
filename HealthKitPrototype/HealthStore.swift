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
    private(set) var activeCalories: Double?
    
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
                        self.activeCaloriesQuery()
                    }
            }
        } else {
            store = nil
        }
    
    }
    
    private func activeCaloriesQuery() {
        guard let activeEnergyType = HKSampleType.quantityType(
            forIdentifier: .activeEnergyBurned
        ) else {
            // This should never fail when using a defined constant.
            fatalError("*** Unable to get the active energy type ***")
        }
        
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
            
        guard let startDate = calendar.date(from: components) else {
            fatalError("*** Unable to create the start date ***")
        }
         
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            fatalError("*** Unable to create the end date ***")
        }

        let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        let query = HKStatisticsQuery(
            quantityType: activeEnergyType,
            quantitySamplePredicate: today,
            options: .cumulativeSum
        ) { (query, statisticsOrNil, errorOrNil) in
            
            guard let statistics = statisticsOrNil else {
                self.activeCalories = 0.0
                return
            }
            
            let sum = statistics.sumQuantity()
            let totalActiveCalories = sum?.doubleValue(for: HKUnit.largeCalorie())
            
            DispatchQueue.main.async {
                self.activeCalories = totalActiveCalories
            }
        }
        
        store?.execute(query)
    }
}
