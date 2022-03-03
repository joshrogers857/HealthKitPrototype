//
//  ContentView.swift
//  HealthKitPrototype
//
//  Created by Joshua Rogers on 03/03/2022.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    private var store = HealthStore.shared
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Active calories burned: \(store.activeCalories ?? 69)")
                .padding()
            
            Text("Basal calories burned: ")
                .padding()
            
            Text("Total calories burned: ")
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
