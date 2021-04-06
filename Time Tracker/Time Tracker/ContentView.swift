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
    @State var overallWorkingTime: TimeInterval = 0.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            VStack {
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
                    self.trackingInProgress ?
                        Image(systemName: "stop")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75.0, height: 75.0) :
                        Image(systemName: "play")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75.0, height: 75.0)
                }
                .frame(width: 150.0, height: 150.0)
                .background(self.trackingInProgress ? Color.red : Color.green)
                .foregroundColor(.white)
                .padding(.vertical, 30.0)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                
               VStack {
                    Text(getOverallTimeString())
                        .font(.system(size: 40.0))
                        .onReceive(timer) { _ in
                            self.overallWorkingTime = self.getOverallWorkingTime()
                        }
                    Text("Working Time").font(.subheadline).foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                List(workingHours) { workingHour in
                    WorkingHourCell(workingHour: workingHour)
                }
                .padding(.vertical)
            
                Divider().foregroundColor(.gray)
                                    
                NotesView(notes: "Dies ist ein Kommentar")
            }
            .navigationBarTitle("\(getCurrentDayString())", displayMode: .automatic)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
        
    func getCurrentDayString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EE, dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        return result
    }
    
    func getOverallWorkingTime() -> TimeInterval {
        var overallWorkingTime: TimeInterval = 0.0
        
        for workingHour in workingHours {
            overallWorkingTime += workingHour.overallTime
        }
        
        return overallWorkingTime
    }
    
    func getOverallTimeString() -> String {
        let interval = Int(self.overallWorkingTime)
        let seconds = (interval % 60)
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(workingHours: testData)
        }
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
        .padding(.vertical)
    }
}

struct WorkingHourCell: View {
    let workingHour: WorkingHours
    
    var body: some View {
        NavigationLink(destination: Text("Test")) {
            Text(workingHour.getStartEndString())
            Spacer()
            if (workingHour.endDate != nil) {
                Text(workingHour.getOverallTimeString())
                               .font(.subheadline)
                               .foregroundColor(.secondary)
            }
        }.disabled(workingHour.endDate == nil)
    }
}
