//
//  ContentView.swift
//  BetterRest
//
//  Created by Ross on 10/20/19.
//  Copyright © 2019 Ross. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAomunt = 6.0
    @State private var coffeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationView{
            Form{
                VStack(alignment: .leading, spacing: 0){
                    Text("When do you want to wake up")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents:.hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                VStack(alignment: .leading, spacing: 0){
                    Text("Desire amount of sleep")
                        .font(.headline)
                    
                    Stepper(value: $sleepAomunt, in: 4...12, step: 0.25){
                        Text("  \(sleepAomunt, specifier: "%g") hours")
                    }
                }
                
                VStack(alignment: .leading, spacing: 0){
                    Text("Daily coffe intake")
                        .font(.headline)
                    
                    Stepper(value: $coffeAmount, in: 1...20){
                        if coffeAmount == 1 {
                            Text("  1 cup")
                        }else{
                            Text("\(coffeAmount) cups")
                        }
                    }
                }
            }
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing:
                Button(action: calculateBedTime){
                    Text("calculate")
                }
            )
                .alert(isPresented: $showAlert){
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton:  .default(Text("OK")))
            }
        }
        
    }
    
    static var defaultWakeTime: Date{
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedTime(){
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try
            model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAomunt, coffee:  Double(coffeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is "
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a [rpblem to calculate your bedtime"
        }
        
        showAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
