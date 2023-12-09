//
//  CalendarViewController.swift
//  SkidCare
//
//  Created by Aaliyah Lawrence on 12/7/23.
//

import Foundation
import UIKit
import EventKit
import EventKitUI
/*
 * CALENDAR PAGE
 *
 * SOURCES:
 * https://developer.apple.com/documentation/uikit/uicalendarview
 * https://medium.com/@ios_guru/custom-view-for-showing-a-calendar-1b512b0f772d
 * https://www.youtube.com/watch?v=B_VFHeg2LH4
 * https://www.youtube.com/watch?v=BgGbQmOAe0I&t=635s
 * TO INCLUDE:
 *  - A calendar view lmao
 *  - Ability to log appointments
 *  - Clickability on dates and whatnot
 *  - Core data to store appointment dates
 *  - Navigation to other pages
 */

//switch to coredata
struct Appointment {
    var date: Date
    var details: String
}


class CalendarViewController: UIViewController,UICalendarViewDelegate{

    var appointments: [Appointment] = []
    var selectedDate: Date!
    var appointmentDetailsTextField: UITextField!
    
    //let today: Date.now
    let scheduleButton: UIButton = {
        let schedulebutton = UIButton(frame: CGRect(x:1,y:-1,width: 200, height: 45))
        schedulebutton.setTitle("Schedule", for: .normal)
        schedulebutton.backgroundColor = .white
        schedulebutton.setTitleColor(.systemBlue, for: .normal)
        return schedulebutton
    }()
    
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createCalendar()
        view.addSubview(scheduleButton)
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.setTitle("Schedule", for: .normal)
        scheduleButton.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scheduleButton.center = view.center
    }
    

    @objc private func scheduleButtonTapped() {
        present(AppointmentSchedulingViewController(), animated: true, completion: nil)
    }
    
    func createCalendar(){
        let calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        calendarView.delegate = self
        calendarView.layer.cornerRadius = 12
        calendarView.backgroundColor = .white
        
        
        
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalToConstant: 300),
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
    }
 
   
    

  
        func appointmentScheduling(for date: Date) {
            let alertController = UIAlertController(title: "Schedule Appointment", message: "Enter appointment details", preferredStyle: .alert)

            alertController.addTextField { textField in
                textField.placeholder = "Details"
            }

            let scheduler = UIAlertAction(title: "Schedule", style: .default) { [weak self] _ in
                guard let details = alertController.textFields?.first?.text else { return }

                let newAppointment = Appointment(date: date, details: details)
                self?.appointments.append(newAppointment)
                //is there a way to highlight a date?


                self?.appointmentDetails(for: date)
            }

            alertController.addAction(scheduler)

            present(alertController, animated: true, completion: nil)
        }

        func appointmentDetails(for date: Date) {
            if let appointment = appointments.first(where: { $0.date == date }) {
                    
                    let details = UILabel()
                    details.translatesAutoresizingMaskIntoConstraints = false
                    details.text = "Appointment Details:\nDate: \(appointment.date)\nDetails: \(appointment.details)"
                    details.numberOfLines = 0
                    details.textColor = .black

                    view.addSubview(details)

                    NSLayoutConstraint.activate([
                        details.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
                        details.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                        details.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
                    ])
                } else {
                    print("No appointment scheduled for the selected date.") //or could be blank
                }
        }
    }

//Extension of Calendar view for scheduling in a core data way


