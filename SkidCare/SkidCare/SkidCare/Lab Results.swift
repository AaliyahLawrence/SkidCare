//
//  Lab Results.swift
//  SkidCare
//
//  Created by Aaliyah Lawrence on 12/11/23.
//
/*
 * LAB RESULTS
 *
 *  TO INCLUDE:
 *  - Cloudkit/core data on whatever lab results given (can't really read skidmore data so idk)
 *  - Navigation to other pages
 * https://developer.apple.com/documentation/uikit/uiimage/creating_custom_symbol_images_for_your_app
 */



import Foundation
import UIKit
class LabViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    let labView: UITableView = {
        let labView = UITableView()
        labView.translatesAutoresizingMaskIntoConstraints = false
        return labView
    }()
    
    //Hardcoded lab results for the time being
    let labResults: [String] = ["COVID-Test", "Iron Levels", "A1C Levels", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        title = "Lab Results"
        labView.delegate = self
        labView.dataSource = self
        labView.register(LabResultCell.self, forCellReuseIdentifier: LabResultCell.reuseIdentifier)
    }
    
    private func setUp() {
        view.backgroundColor = UIColor.white
        view.addSubview(labView)
        
        NSLayoutConstraint.activate([
            labView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            labView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            labView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            labView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LabResultCell.reuseIdentifier, for: indexPath) as? LabResultCell {
            //Hardcoded alternate status resluts for now
            let status: LabStatus = indexPath.row % 3 == 0 ? .check : indexPath.row % 3 == 1 ? .caution : .xmark
            cell.configure(with: labResults[indexPath.row], status: status)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}

enum LabStatus {
     case check, caution, xmark
     
     var image: UIImage? {
         switch self {
         case .check: return UIImage(systemName: "checkmark.circle")
         case .caution: return UIImage(systemName: "exclamationmark.circle")
         case .xmark: return UIImage(systemName: "xmark.circle")
         }
     }
     
     var tintColor: UIColor {
         switch self {
         case .check: return UIColor.systemGreen
         case .caution, .xmark: return UIColor.systemRed
         }
     }
 }

class LabResultCell: UITableViewCell {
    static let reuseIdentifier = "LabResultCell"
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
    }
    
    //Was a fix from an error
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCell() {
        contentView.addSubview(statusImageView)
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            statusImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusImageView.heightAnchor.constraint(equalToConstant: 30),
            statusImageView.widthAnchor.constraint(equalToConstant: 30),
            
            title.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 20),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with labResult: String, status: LabStatus) {
        title.text = labResult
        statusImageView.image = status.image
        statusImageView.tintColor = status.tintColor
    }
}
        
        
        
