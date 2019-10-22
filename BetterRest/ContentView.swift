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
    
    let coffeCups = [1,2,3,4,5,6,7,8,9]
    
    static var defaultWakeTime: Date{
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var debTime: String{
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
            
            return formatter.string(from: sleepTime)
        } catch {
            return "Sorry there was a problem calculating your bedtime"
        }
        
    }
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    Section(header: Text("When do you want to wake up")){
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents:.hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                    
                    Section(header: Text("Desire amount of sleep")){
                        Stepper(value: $sleepAomunt, in: 4...12, step: 0.25){
                            Text("  \(sleepAomunt, specifier: "%g") hours")
                        }
                    }
                    
                    Section(header: Text("Coffe amount")){
                        Picker("Cup of coffe", selection: $coffeAmount){
                            ForEach(0...5, id: \.self){
                                Text("\($0)")
                            }
                        }.pickerStyle(WheelPickerStyle())
                    }
                    
                    Section(header: Text("Bad Time :")){
                        Text("\(debTime)")
                            .font(.headline)
                    }
                }
            }
            .navigationBarTitle("BetterRest")
//            .navigationBarItems(trailing:
//                Button(action: calculateBedTime){
//                    Text("calculate")
//                }
//            )
//                .alert(isPresented: $showAlert){
//                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton:  .default(Text("OK")))
//            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
