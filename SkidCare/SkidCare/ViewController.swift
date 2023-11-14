//
//  ViewController.swift
//  SkidCare
//
//  Created by Aaliyah Lawrence on 11/13/23.
//

import UIKit

class ViewController: UIViewController {
    
    //Place credentials fields here
    
    //Ideally would be a log-in page for skidmore
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Log IN", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.green, for: .normal)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        view.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.center = view.center
    }
    
    //Different Tab Views, unclear if going to rearange for a homeScreen or anything idk
    
    @objc func didTapButton() {
        let tabBarVC = UITabBarController()
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        vc1.title = "Home"
        let vc2 = UINavigationController(rootViewController: MessageViewController())
        vc2.title = "Messages"
        let vc3 = UINavigationController(rootViewController: CalendarViewController())
        vc3.title = "Calendar"
        let vc4 = UINavigationController(rootViewController: PrescriptionViewController())
        vc4.title = "Lab Results"
        let vc5 = UINavigationController(rootViewController: LabViewController())
        vc5.title = "Prescriptions"
        
        tabBarVC.setViewControllers([vc1,vc2,vc3,vc4,vc5], animated: false)
        
        guard let items = tabBarVC.tabBar.items else{
            return
        }
        
        let images = ["house","person.circle","bell", "star", "gear"]
        
        for x in 0..<items.count{
            items[x].badgeValue="1"
            items[x].image = UIImage(systemName: images[x])
        }
        
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }

}

/*
 * THIS IS CODE FOR THE HOMEPAGE
 *
 * TO INCLUDE:
 *  - Profile photo page
 *  - Navigation to other pages
 *  - Include the notification Text example Fields
 */

class HomeViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        title = "Home"
    }
}

/*
 * MESSAGE PAGE
 *
 * TO INCLUDE:
 *  - List of messages
 *  - Core datafy the messages
 *  - Navigation to other pages
 */

class MessageViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        title = "Messages"
    }
}


/*
 * CALENDAR PAGE
 *
 * SOURCES:
 * https://developer.apple.com/documentation/uikit/uicalendarview
 * https://medium.com/@ios_guru/custom-view-for-showing-a-calendar-1b512b0f772d
 *
 * TO INCLUDE:
 *  - A calendar view lmao
 *  - Ability to log appointments
 *  - Clickability on dates and whatnot
 *  - Core data to store appointment dates
 *  - Navigation to other pages
 */

class CalendarViewController: UIViewController{
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

/*
 * PRESCRIPTIONS
 *
 * TO INCLUDE:
 *  - Ability to add and log prescriptions
 *  - Navigation to other pages
 */

class PrescriptionViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        title = "Precriptions"
    }
}

/*
 * LAB RESULTS
 *
 *  TO INCLUDE:
 *  - Cloudkit/core data on whatever lab results given (can't really read skidmore data so idk)
 *  - Navigation to other pages
 */

class LabViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        title = "Lab Results"
    }


}

