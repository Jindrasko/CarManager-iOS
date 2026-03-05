//
//  Event+CoreDataProperties.swift
//  car_manager
//
//  Created by Jindra on 11.06.2022.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var cost: Double
    @NSManaged public var done: Bool
    @NSManaged public var eventCategory: EventCategory
    @NSManaged public var everyKm: Int32
    @NSManaged public var everyMonth: Int32
    @NSManaged public var longDescription: String?
    @NSManaged public var onceAtKm: Int32
    @NSManaged public var onceDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var location: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var eventXVehicle: Vehicle?
    
    

}

extension Event : Identifiable {

}
