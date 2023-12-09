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
    var time: String
}


class CalendarViewController: UIViewController,UICalendarViewDelegate,  UITableViewDataSource, UITableViewDelegate,  UICalendarSelectionSingleDateDelegate{
    
    private var appointments = [Appointment]()
    var appointmentView: UITableView!
    
    var selectedDate: Date!
    var appointmentDetailsTextField: UITextField!
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
        setupApptView()
        //view.addSubview(scheduleButton)
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.setTitle("Schedule", for: .normal)
        scheduleButton.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scheduleButton.center = view.center
    }
    
    @objc private func scheduleButtonTapped() {
        let appointmentSchedulingVC = AppointmentSchedulingViewController()
        appointmentSchedulingVC.delegate = self
        navigationController?.pushViewController(appointmentSchedulingVC, animated: true)
        updateUI()
    }

    let calendarView = UICalendarView()
    func createCalendar(){
        calendarView.delegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        
        calendarView.layer.cornerRadius = 12
        calendarView.backgroundColor = .white
        view.addSubview(calendarView)
        if appointments.isEmpty {
            view.addSubview(scheduleButton)
        }
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        
        
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalToConstant: 300),
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
    }
    
    
     func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
         guard let selectedDate = dateComponents?.date else{
             return
         }
         let appointmentSchedulingVC = AppointmentSchedulingViewController()
                appointmentSchedulingVC.delegate = self
         appointmentSchedulingVC.selectedDate = dateComponents?.date
                navigationController?.pushViewController(appointmentSchedulingVC, animated: true)
            updateUI()
     }
    
    
    
    
    func setupApptView() {
        appointmentView = UITableView()
        appointmentView.translatesAutoresizingMaskIntoConstraints = false
        appointmentView.delegate = self
        appointmentView.dataSource = self
        appointmentView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
        view.addSubview(appointmentView)
            
        NSLayoutConstraint.activate([
            appointmentView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
            appointmentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            appointmentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            appointmentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
       
       func saveAppointment(date: Date, timeSlot: String, appointmentType: String) {
           let newAppointment = Appointment(date: date, details: appointmentType, time: timeSlot)
           appointments.append(newAppointment)           
           updateUI()
       }
       
       func updateUI() {
           appointmentView.reloadData()
           calendarUIUpdate()
           scheduleButton.isHidden = !appointments.isEmpty
           
       }
    
    func calendarUIUpdate(){
        if let selectedDate = selectedDate {
            let selectedDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
            let selectedDateDecoration = UICalendarView.Decoration()
            calendarView.reloadDecorations(forDateComponents: [selectedDateComponents], animated: true)
        } else {
            print("Selected date is nil.")
        }
            
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return appointments.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let appointment = appointments[indexPath.row]
            cell.textLabel?.text = "\(appointment.time) - \(appointment.details)"
            return cell
        }
    
    
    /*This presented the schedule as an alert, similar to our todo app example
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
     */
    
}
