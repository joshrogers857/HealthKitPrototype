//
//  ContentView.swift
//  HealthKitPrototype
//
//  Created by Joshua Rogers on 03/03/2022.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @State private var activeCalories: HKQuantitySample?
    @State private var basalCalories: HKQuantitySample?
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Active calories burned: ").padding()
            
            Text("Basal calories burned: ").padding()
            
            Text("Total calories burned: ").padding()
        }
    }
    
    init() {
        HealthStore.shared.store
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
