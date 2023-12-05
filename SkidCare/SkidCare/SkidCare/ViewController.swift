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
    
    //Ideally would be a log-in page for skidmore
    private let button: UIButton = {
        let button = UIButton(frame: CGRect(x:1,y:1,width: 200, height: 45))
        button.setTitle("Log In", for: .normal)
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
        let vc2 = UINavigationController(rootViewController: MessageViewController())
        vc2.title = "Alerts"
        let vc3 = UINavigationController(rootViewController: CalendarViewController())
        vc3.title = "Calendar"
        let vc4 = UINavigationController(rootViewController: PrescriptionViewController())
        vc4.title = "Prescriprions"
        let vc5 = UINavigationController(rootViewController: LabViewController())
        vc5.title = "Lab Results"
        
        tabBarVC.setViewControllers([vc5,vc3,vc4,vc2], animated: false)
        
        guard let items = tabBarVC.tabBar.items else{
            return
        }
        
        let images = ["house","alert","calendar", "list.clipboard", "pills"]
        
        for x in 0..<items.count{
            if(x % 2==0){
                items[x].badgeValue = "2"
                
            }
        }
        items[1].image = UIImage(systemName: images[2])
        items[0].image = UIImage(systemName: images[3])
        items[2].image = UIImage(systemName: images[4])
        items[3].image = UIImage(systemName: images[1])
        
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
 * CALENDAR PAGE
 *
 * SOURCES:
 * https://developer.apple.com/documentation/uikit/uicalendarview
 * https://medium.com/@ios_guru/custom-view-for-showing-a-calendar-1b512b0f772d
 * https://www.youtube.com/watch?v=B_VFHeg2LH4
 *
 * TO INCLUDE:
 *  - A calendar view lmao
 *  - Ability to log appointments
 *  - Clickability on dates and whatnot
 *  - Core data to store appointment dates
 *  - Navigation to other pages
 */

class CalendarViewController: UIViewController,UICalendarViewDelegate, EKEventViewDelegate{
    let apptStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createCalendar()
        addEvents()
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
    func addEvents(){
       
        func addButton(_ sender: Any){
            apptStore.requestWriteOnlyAccessToEvents()
            { [weak self] success, error in
                if success, error == nil{
                    DispatchQueue.main.async {
                        guard let store = self?.apptStore else {return}
                        
                        let newAppt = EKEvent(eventStore: store)
                        newAppt.title = "Schedule Appointment"
                        newAppt.startDate = Date()
                        
                        let eventController = EKEventViewController()
                        eventController.delegate = self
                        eventController.event = newAppt
                        self?.present(eventController, animated: true, completion: nil)
                    }
                }
                
            }
        }
    }
   
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        //pls idc
    }

}
    

/*
 * PRESCRIPTIONS
 *
 * TO INCLUDE:
 *  - Ability to add and log prescriptions
 *  - Navigation to other pages
 */

class PrescriptionViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var models = [PrescriptionItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        title = "Precriptions"
        view.addSubview(tableView)
        getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "New Item", message: "Enter new item", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{
            return
        }
            self?.createItem(name: text)
        }))
        present(alert,animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.label
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        
        let sheet = UIAlertController(title: "Edit",
                                      message: nil,
                                      preferredStyle: .alert)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Edit Item", message: "Edit your item", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.label
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else{
                return
            }
                self?.updateItem(item: item, newName: newName)
            }))
            self.present(alert,animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler:{[weak self]_ in
            self?.deleteItem(item: item)
        }))
        
        present(sheet,animated: true)
        
    }
    
    //Core Data
    
    func getAllItems() {
        do{
            models = try context.fetch(PrescriptionItem.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            //error
        }
        
        
    }
    
    func createItem(name: String) {
        let newItem = PrescriptionItem(context: context)
        newItem.label = name
        
        do{
            try context.save()
            getAllItems()
        } catch{
            //error
        }
    }
    
    func deleteItem(item: PrescriptionItem) {
        context.delete(item)
        
        do{
            try context.save()
            getAllItems()
        }catch{
            //error
        }
    }
    
    func updateItem(item: PrescriptionItem, newName: String) {
        item.label = newName
        
        do{
            try context.save()
            getAllItems()
        } catch{
            //error
        }
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

    
           enum Status {
               case check, cross, caution

               var image: UIImage? {
                   switch self {
                   case .check: return UIImage(systemName: "checkmark.circle.fill")
                   case .cross: return UIImage(systemName: "xmark.circle.fill")
                   case .caution: return UIImage(systemName: "exclamationmark.circle.fill")
                   }
               }
           }

           let statusImageView: UIImageView = {
               let imageView = UIImageView()
               imageView.translatesAutoresizingMaskIntoConstraints = false
               imageView.tintColor = UIColor.systemGreen // Change the color as needed
               return imageView
           }()

           let tableView: UITableView = {
               let tableView = UITableView()
               tableView.translatesAutoresizingMaskIntoConstraints = false
               return tableView
           }()
    
            //Hardcoded lab results for the time being
           let labResults: [String] = ["COVID-Test", "Iron Levels", "A1C Levels"]

    
           var currentStatus: Status = .check {
               didSet {
                   statusImageView.image = currentStatus.image
               }
           }

           override func viewDidLoad() {
               super.viewDidLoad()

               setUp()

               tableView.delegate = self
               tableView.dataSource = self
               tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LabResultCell")
           }

           private func setUp() {
               view.backgroundColor = UIColor.white

               view.addSubview(statusImageView)
               view.addSubview(tableView)

               NSLayoutConstraint.activate([
                   statusImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                   statusImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   statusImageView.heightAnchor.constraint(equalToConstant: 50),
                   statusImageView.widthAnchor.constraint(equalToConstant: 50),

                   tableView.topAnchor.constraint(equalTo: statusImageView.bottomAnchor, constant: 20),
                   tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                   tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                   tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
