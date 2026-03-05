//
//  Vehicle+CoreDataProperties.swift
//  car_manager
//
//  Created by Jindra on 11.06.2022.
//
//

import Foundation
import CoreData


extension Vehicle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vehicle> {
        return NSFetchRequest<Vehicle>(entityName: "Vehicle")
    }

    @NSManaged public var color: String?
    @NSManaged public var dateOfPurchase: Date?
    @NSManaged public var fuelType: FuelType
    @NSManaged public var image: Data?
    @NSManaged public var licencePlate: String?
    @NSManaged public var manufacturer: String?
    @NSManaged public var model: String?
    @NSManaged public var title: String?
    @NSManaged public var vin: String?
    @NSManaged public var yearOfManufacture: Int16
    @NSManaged public var mileage: Int32
    @NSManaged public var vehicleXEvent: NSSet?

}

// MARK: Generated accessors for vehicleXEvent
extension Vehicle {

    @objc(addVehicleXEventObject:)
    @NSManaged public func addToVehicleXEvent(_ value: Event)

    @objc(removeVehicleXEventObject:)
    @NSManaged public func removeFromVehicleXEvent(_ value: Event)

    @objc(addVehicleXEvent:)
    @NSManaged public func addToVehicleXEvent(_ values: NSSet)

    @objc(removeVehicleXEvent:)
    @NSManaged public func removeFromVehicleXEvent(_ values: NSSet)

}

extension Vehicle : Identifiable {

}
