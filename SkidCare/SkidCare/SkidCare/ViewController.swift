//
//  ViewController.swift
//  SkidCare
//
//  Created by Aaliyah Lawrence on 11/13/23.
//

import UIKit
import EventKit
import EventKitUI

class ViewController: UIViewController {
    
    //Place credentials fields here
    private let iDField: UITextField = {
        let idField = UITextField(frame: CGRect(x: 1, y: 1, width: 200, height: 30))
        idField.backgroundColor = .white
        idField.text = "Enter ID Number"
        idField.textColor = .systemGreen
        //idField.borderStyle = UITextField.BorderStyle.line
        return idField
    }()
    //Ideally would be a log-in page for skidmore
    private let button: UIButton = {
        let button = UIButton(frame: CGRect(x:1,y:-1,width: 200, height: 45))
        button.setTitle("SkidCare", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.green, for: .normal)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        //view.addSubview(iDField)
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
        let vc3 = UINavigationController(rootViewController: CalendarViewController())
        vc3.title = "Schedule Appointment"
        let vc4 = UINavigationController(rootViewController: PrescriptionViewController())
        vc4.title = "Prescriprions"
        let vc5 = UINavigationController(rootViewController: LabViewController())
        vc5.title = "Lab Results"
        
        tabBarVC.setViewControllers([vc5,vc3,vc4], animated: false)
        
        guard let items = tabBarVC.tabBar.items else{
            return
        }
        
        let images = ["house","calendar", "list.clipboard", "pills"]
        
        for x in 0..<items.count{
            if(x % 2==0){
                items[x].badgeValue = "2"
                
            }
        }
        items[0].image = UIImage(systemName: images[2])
        items[1].image = UIImage(systemName: images[1])
        items[2].image = UIImage(systemName: images[3])
       
        
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
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

class MessageViewController: UIViewController, UITableViewDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        title = "Alerts"
    }
}
    
    
    
