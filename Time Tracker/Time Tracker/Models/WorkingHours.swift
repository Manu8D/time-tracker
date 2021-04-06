//
//  WorkingHours.swift
//  Time Tracker
//
//  Created by Manuel Schwandt on 10.06.20.
//  Copyright © 2020 Schwandt. All rights reserved.
//

import SwiftUI

struct WorkingHours: Identifiable {
    var id =  UUID()
    var startDate: Date
    var endDate: Date?
    var overallTime: TimeInterval {
        get {
            return (endDate != nil) ? endDate!.timeIntervalSince(startDate) : -startDate.timeIntervalSinceNow
        }
    }
    var entryComplete: Bool {
        endDate != nil
    }
    
    func getStartEndString() -> String {
        let calender = Calendar.current
        let units: Set<Calendar.Component> = [.hour, .minute]

        let startTime = calender.dateComponents(units, from: startDate)
        var timeString = String(format: "%02i:%02i - ", startTime.hour!, startTime.minute!)
        
        if endDate != nil {
            let endTime = calender.dateComponents(units, from: endDate!)
            timeString += " " + String(format: "%02i:%02i", endTime.hour!, endTime.minute!)
        }
        
        return timeString
    }
    
    func getOverallTimeString() -> String {
        let interval = Int(overallTime)
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        
        return String(format: "%02i:%02i", hours, minutes)
    }
}

#if DEBUG
let testData = [
    WorkingHours(startDate: Date(timeIntervalSinceNow: -15000), endDate: Date(timeIntervalSinceNow: -1800)),
    WorkingHours(startDate: Date(timeIntervalSinceNow: -15000), endDate: Date(timeIntervalSinceNow: -3200)),
    WorkingHours(startDate: Date(timeIntervalSinceNow: -15000), endDate: Date(timeIntervalSinceNow: -2000)),
    WorkingHours(startDate: Date(timeIntervalSinceNow: -15000), endDate: Date(timeIntervalSinceNow: -1500)),
    WorkingHours(startDate: Date(timeIntervalSinceNow: -15000), endDate: Date(timeIntervalSinceNow: -1000)),
    WorkingHours(startDate: Date(timeIntervalSinceNow: -15000), endDate: Date(timeIntervalSinceNow: -800)),
    WorkingHours(startDate: Date(timeIntervalSinceNow: -15000), endDate: Date(timeIntervalSinceNow: -800)),
]
#endif
