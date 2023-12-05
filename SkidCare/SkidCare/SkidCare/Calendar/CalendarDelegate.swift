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
/*
 @MainActor
 
 var calendarView: UICalendarView = {
 let calendarObject = UICalendarView()
 calendarObject.calendar = Calendar(identifier: .gregorian)
 
 return calendarObject
 }()
 
 var calendarDelegate: CalendarDelegate!
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 calendarDelegate = CalendarDelegate()
 calendarView.delegate = calendarDelegate
 
 view.backgroundColor = .white
 title = "Calendar"
 }
 
 
 func setupUI() {
 
 view.addSubview(calendarView)
 
 calendarView.translatesAutoresizingMaskIntoConstraints = false
 calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
 calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
 calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
 calendarView.heightAnchor.constraint(equalToConstant: 500).isActive = true
 
 
 
 }
 
 
 
 
 }
 */
