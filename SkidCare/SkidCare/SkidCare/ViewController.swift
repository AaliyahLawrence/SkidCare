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
        vc3.title = "Calendar"
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
    
    /*
     * LAB RESULTS
     *
     *  TO INCLUDE:
     *  - Cloudkit/core data on whatever lab results given (can't really read skidmore data so idk)
     *  - Navigation to other pages
     * https://developer.apple.com/documentation/uikit/uiimage/creating_custom_symbol_images_for_your_app
     */
    
class LabViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
            /*
               var image: UIImage? {
                   switch self {
                       //Included pngs downloaded from the sf app
                   case check: return UIImage(systemName: "checkmark.circle")
                   case cross: return UIImage(systemName: "xmark.circle")
                   case caution: return UIImage(systemName: "questionmark.circle")
                   }
               }
           */
    
    //Change to func depending on the status of a test
           let statusImageView: UIImageView = {
               let imageView = UIImageView()
               imageView.translatesAutoresizingMaskIntoConstraints = false
               imageView.tintColor = UIColor.systemGreen // Change the color as needed
               imageView.frame.size = CGSize(width: 2000, height: 450)
               imageView.image = UIImage(systemName: "checkmark.circle")
               return imageView
           }()

           let labView: UITableView = {
               let labView = UITableView()
               labView.translatesAutoresizingMaskIntoConstraints = false
               return labView
           }()
    
            //Hardcoded lab results for the time being
           let labResults: [String] = ["COVID-Test", "Iron Levels", "A1C Levels", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test"]
    
      

        
    
    
        
          
           override func viewDidLoad() {
               super.viewDidLoad()

               setUp()

               labView.delegate = self
               labView.dataSource = self
               labView.register(UITableViewCell.self, forCellReuseIdentifier: "LabResultCell")
           }

           private func setUp() {
               view.backgroundColor = UIColor.white

               view.addSubview(statusImageView)
               view.addSubview(labView)

               NSLayoutConstraint.activate([
                   statusImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                   statusImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   statusImageView.heightAnchor.constraint(equalToConstant: 50),
                   statusImageView.widthAnchor.constraint(equalToConstant: 50),

                   labView.topAnchor.constraint(equalTo: statusImageView.bottomAnchor, constant: 20),
                   labView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                   labView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                   labView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
               ])
           }


           func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return labResults.count
           }

           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               let cell = tableView.dequeueReusableCell(withIdentifier: "LabResultCell", for: indexPath)
               cell.textLabel?.text = labResults[indexPath.row]
               return cell
           }
    }
        
        
        
    
extension ViewController: UICalendarViewDelegate,UICalendarSelectionSingleDateDelegate{
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return nil
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        //
    }
    
   
    
}
