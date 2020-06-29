//
//  ContentView.swift
//  Time Tracker
//
//  Created by Manuel Schwandt on 27.06.20.
//  Copyright © 2020 Schwandt. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var workingHours: [WorkingHours] = []
    @State var trackingInProgress = false
    
    var body: some View {
        VStack {
            Text("Do, 16.06.2020")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding(.vertical)
            if true {
                Button(action: {
                    if (self.trackingInProgress) {
                        // Add Endtime to latest workingHour
                        self.workingHours[self.workingHours.count - 1].endDate = Date()
                    }
                    else {
                        self.workingHours.append(WorkingHours(startDate: Date()))
                    }
                    
                    self.trackingInProgress.toggle()
                }) {
                    Text(self.trackingInProgress ? "Stop" : "Start").font(.largeTitle)
                }
                .frame(width: 150.0, height: 150.0)
                .background(self.trackingInProgress ? Color.red : Color.green)
                .foregroundColor(Color.white)
                .cornerRadius(10.0)
            } else {
                EmptyView()
            }
            
            Spacer()
            Text("Overall: \(getOverallTimeString())")
            List(workingHours) { workingHour in
                Text(workingHour.getStartEndString())
                Spacer()
                Text(workingHour.getOverallTimeString())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical)
                            
            NotesView(notes: "Dies ist ein Kommentar")
        }
    }
    
    func getOverallWorkingTime() -> TimeInterval {
        var overallWorkingTime: TimeInterval = 0.0
        
        for workingHour in workingHours {
            if workingHour.entryComplete {
                overallWorkingTime += workingHour.overallTime
            }
        }
        
        return overallWorkingTime
    }
    
    func getOverallTimeString() -> String {
        let overallWorkingTime = self.getOverallWorkingTime()
        
        let interval = Int(overallWorkingTime)
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        
        return String(format: "%02i:%02i", hours, minutes)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(workingHours: testData)
    }
}
#endif

struct NotesView: View {
    @State var notes = ""

    var body: some View {
        VStack {
            HStack {
                Text("Notes")
                    .font(.subheadline)
                    .padding(.leading)
                Spacer()
            }
            TextField("You can add notes here", text: $notes)
                .padding(.leading)
                .foregroundColor(.secondary)
        }
        .padding(.bottom)
    }
}
