//
//  ScheduleViewController.swift
//  SkidCare
//
//  Created by Aaliyah Lawrence on 12/8/23.
// SOURCES:
//https://www.youtube.com/watch?v=l6Gj_goCWAY
//

import Foundation
import UIKit
/* When date is clicked
appointmentDetailsTextField = UITextField()
appointmentDetailsTextField.translatesAutoresizingMaskIntoConstraints = false
appointmentDetailsTextField.placeholder = "Enter appointment details"
appointmentDetailsTextField.borderStyle = .roundedRect
view.addSubview(appointmentDetailsTextField)



NSLayoutConstraint.activate([
    appointmentDetailsTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
    appointmentDetailsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
    appointmentDetailsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

    scheduleButton.topAnchor.constraint(equalTo: appointmentDetailsTextField.bottomAnchor, constant: 20),
    scheduleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
])*/
//appointmentScheduling(for: Date.now)
//appointmentDetails(for: Date.now)

class AppointmentSchedulingViewController: UIViewController, UIScrollViewDelegate /*Have table and delegate here to core datafy the appointments*/ {
    let timeScrollView = UIScrollView()
    let apptScrollView = UIScrollView()
    var selectedTimeSlots: [String] = []
    var selectedAppointments: [String] = []
    

    let timeSlots = ["9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM"]
    
    let apptTypes = ["Physical","STI Testing","Family Planning","Chronic Illness Management","Counceling Center"]


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Schedule Appointment..."
        setupTimeScrollView()
        setupApptScrollView()
        populateTimeSlots()
        appTypepopulate()

     
    }

    /* Scrollview for time */
    func setupTimeScrollView() {
        timeScrollView.frame = CGRect(x: 0, y: 50, width: view.bounds.width, height: 44.0)
        timeScrollView.contentSize = CGSize(width: CGFloat(timeSlots.count) * 100.0, height: 44.0)
        timeScrollView.showsHorizontalScrollIndicator = true
        timeScrollView.isDirectionalLockEnabled = true
        timeScrollView.delegate = self
        view.addSubview(timeScrollView)
       }

    func populateTimeSlots() {
        var xOffset: CGFloat = 0.0

        for (index, timeSlot) in timeSlots.enumerated() {
            let timeSlotLabel = UILabel(frame: CGRect(x: xOffset, y: 0, width: 100.0, height: 44.0))
            timeSlotLabel.text = timeSlot
            timeSlotLabel.textAlignment = .center
            timeSlotLabel.isUserInteractionEnabled = true
            timeSlotLabel.tag = index
            timeSlotLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(timeSlotTapped(_:))))
            timeScrollView.addSubview(timeSlotLabel)
            xOffset += 100.0
            }
        }

    @objc func timeSlotTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        if let selectedTimeSlotLabel = gestureRecognizer.view as? UILabel {
            for subview in timeScrollView.subviews {
                if let label = subview as? UILabel {
                    label.backgroundColor = UIColor.clear
                }
            }
            selectedTimeSlotLabel.backgroundColor = UIColor.systemBlue
            if let selectedTimeSlot = selectedTimeSlotLabel.text, !selectedTimeSlots.contains(selectedTimeSlot) {
                selectedTimeSlots.append(selectedTimeSlot)
            }
        }
      
    }
    
    
    
    /* Scrollview for appt type */
    func setupApptScrollView() {
        apptScrollView.frame = CGRect(x: 0, y: 300, width: 200, height: 44.0)
        apptScrollView.contentSize = CGSize(width: CGFloat(apptTypes.count) * 100.0, height: 44.0)
        apptScrollView.showsHorizontalScrollIndicator = true
        apptScrollView.isDirectionalLockEnabled = true
        apptScrollView.delegate = self
        
        view.addSubview(apptScrollView)
       }
    func appTypepopulate() {
        var xOffset: CGFloat = 0.0

        for (index, apptTypes) in apptTypes.enumerated() {
            let appTypeLabel = UILabel(frame: CGRect(x: xOffset, y: 0, width: 100.0, height: 44.0))
            appTypeLabel.text = apptTypes
            appTypeLabel.textAlignment = .center
            appTypeLabel.isUserInteractionEnabled = true
            appTypeLabel.tag = index
            appTypeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(appTypeTapped(_:))))
            apptScrollView.addSubview(appTypeLabel)
            xOffset += 100.0
            }
        }

    @objc func appTypeTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        if let selectedAppTypeLabel = gestureRecognizer.view as? UILabel {
            for subview in apptScrollView.subviews {
                if let label = subview as? UILabel {
                    label.backgroundColor = UIColor.clear
                }
            }
            selectedAppTypeLabel.backgroundColor = UIColor.systemGreen
            if let selectedAppType = selectedAppTypeLabel.text, !selectedAppointments.contains(selectedAppType) {
                selectedAppointments.append(selectedAppType)
            }
            }
        }
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTimeSlots.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = selectedTimeSlots[indexPath.row]
            return cell
        }
    func tableView1(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedAppointments.count
        }

        func tableView1(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = selectedAppointments[indexPath.row]
            return cell
        }
     */
     
}
