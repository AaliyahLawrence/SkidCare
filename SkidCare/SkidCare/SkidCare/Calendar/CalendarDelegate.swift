//
//  CalendarDelegate.swift
//  SkidCare
// Data can be stored here
// Maybe move all calendar View stuff into this controller
//  Created by Aaliyah Lawrence on 11/14/23.
// Credits to: https://www.youtube.com/watch?v=BgGbQmOAe0I

import UIKit

class CalendarDelegate: NSObject, UICalendarViewDelegate{
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) ->UICalendarView.Decoration?{
        return .none
    }
}
