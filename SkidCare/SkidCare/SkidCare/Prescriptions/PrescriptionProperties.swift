//
//  PrescriptionProperties.swift
//  SkidCare
//
//  Created by Aaliyah Lawrence on 11/16/23.
//

import Foundation
import CoreData


extension PrescriptionItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PrescriptionItem> {
        return NSFetchRequest<PrescriptionItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var label: String?
    

}

extension PrescriptionItem : Identifiable {

}
