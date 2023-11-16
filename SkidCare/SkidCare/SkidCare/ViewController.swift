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
        
        let images = ["house","ellipsis.message","calendar", "list.clipboard", "pills"]
        
        for x in 0..<items.count{
            if(x % 2==0){
                items[x].badgeValue = "2"
                items[x].image = UIImage(systemName: images[x])
            }
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

class MessageViewController: UIViewController, UITableViewDelegate{
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
     */
    
    class LabViewController: UIViewController{
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemMint
            title = "Lab Results"
        }
        
        
    }
    

