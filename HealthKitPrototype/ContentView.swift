//
//  ContentView.swift
//  HealthKitPrototype
//
//  Created by Joshua Rogers on 03/03/2022.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @ObservedObject var healthStore = HealthStore.shared
    
    var body: some View {
        VStack(spacing: 10) {
            if(healthStore.store == nil) {
                Text("HealthStore unavailable")
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                    .padding()
            } else {
                Text("Active calories burned: \(healthStore.activeCalories)")
                    .padding()
                            
                Text("Basal calories burned: \(healthStore.basalCalories)")
                    .padding()
                            
                Text("Total calories burned: \(healthStore.totalCalories)")
                    .padding()
            }
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
