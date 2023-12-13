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

class AppointmentSchedulingViewController: UIViewController, UIScrollViewDelegate /*Have table and delegate here to core datafy the appointments*/ {
    let timeScrollView = UIScrollView()
    let apptScrollView = UIScrollView()
    var selectedTimeSlots: [String] = []
    var selectedAppointments: [String] = []
    var selectedDate: Date?
    weak var delegate: CalendarViewController?
    
    
  
    

    let timeSlots = ["9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM"]
    
    let apptTypes = ["Physical","STI Testing","Family Planning","Chronic Illness Management","Counceling Center"]

    
    let scheduleButton: UIButton = {
        let schedulebutton = UIButton(frame: CGRect(x:1,y:-1,width: 200, height: 45))
        schedulebutton.setTitle("Save", for: .normal)
        schedulebutton.backgroundColor = .white
        schedulebutton.setTitleColor(.systemBlue, for: .normal)
        return schedulebutton
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Schedule Appointment..."
        setupTimeScrollView()
        setupApptScrollView()
        populateTimeSlots()
        appTypepopulate()
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.setTitle("Save", for: .normal)
        scheduleButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(scheduleButton)
        
        //Adding photo to op of screen
        //Resource: https://stackoverflow.com/questions/55916477/how-to-add-image-view-with-some-constraints-programmatically-using-swift?answertab=modifieddesc#tab-top
        let imageName = "SkidmoreTbred.jpeg"
        let tBred = UIImage(named: imageName)
        let tBView = UIImageView(image: tBred!)
        tBView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
        
        view.addSubview(tBView)
        tBView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tBView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tBView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tBView.heightAnchor.constraint(equalToConstant: 300),
            tBView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        
        //to avoid overlapping with the other scrollview and image
        NSLayoutConstraint.activate([
            timeScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            timeScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            timeScrollView.topAnchor.constraint(equalTo: tBView.bottomAnchor, constant: 10)
            
        ])
        
        NSLayoutConstraint.activate([
            apptScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            apptScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            apptScrollView.topAnchor.constraint(equalTo: timeScrollView.bottomAnchor, constant: 10),
            
        ])

     
    }
    

 

        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scheduleButton.center = view.center
    }

    /* Scrollview for time */
    func setupTimeScrollView() {
        timeScrollView.frame = CGRect(x: 0, y: 250, width: view.bounds.width, height: 44.0)
        timeScrollView.contentSize = CGSize(width: CGFloat(timeSlots.count) * 100.0, height: 44.0)
        timeScrollView.showsHorizontalScrollIndicator = true
        timeScrollView.isDirectionalLockEnabled = true
        timeScrollView.delegate = self
        view.addSubview(timeScrollView)
        NSLayoutConstraint.activate([
            timeScrollView.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            timeScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            timeScrollView.heightAnchor.constraint(equalToConstant: 300),
            timeScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
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
        apptScrollView.frame = CGRect(x: 0, y: 300, width: view.bounds.width, height: 44.0)
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
            appTypeLabel.textAlignment = .left
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
    
    @objc private func saveButtonTapped() {
            guard let selectedDate = selectedDate,
                  let selectedTimeSlot = selectedTimeSlots.first,
                  let selectedAppointmentType = selectedAppointments.first else {
                
                //field is not selected
                return
            }
            
        delegate?.saveAppointment(date: selectedDate, timeSlot: selectedTimeSlot, appointmentType: selectedAppointmentType)
        
        if let calendarVC = navigationController?.viewControllers.first(where: { $0 is CalendarViewController }) as? CalendarViewController {
            calendarVC.updateUI()
            navigationController?.popToViewController(calendarVC, animated: true)
        }

            }
}
   
     

