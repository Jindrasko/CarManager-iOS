//
//  FuelTypeEnum.swift
//  car_manager
//
//  Created by Jindra on 09.06.2022.
//

import Foundation
import UIKit

@objc
public enum FuelType : Int16, CaseIterable, Identifiable{
    case gasoline
    case diesel
    case biodiesel
    case LPG
    case CNG
    case electricity
    
    public var id: Self { self }
    
    func typeName() -> String {
        switch self {
        case .gasoline:
            return "Gasoline"
        case .diesel:
            return "Diesel"
        case .biodiesel:
            return "BioDiesel"
        case .LPG:
            return "LPG"
        case .CNG:
            return "CNG"
        case .electricity:
            return "Electticity"
        }
    }
    
}

@objc
public enum EventCategory : Int16, CaseIterable, Identifiable {
    
    case maintenance
    case taxes
    case toll
    case repairs
    
    public var id: Self { self }
    
    
    func eventName() -> String {
        switch self {
        case .maintenance:
            return "Maintenance"
        case .taxes:
            return "Taxes"
        case .toll:
            return "Toll"
        case .repairs:
            return "Repairs"
        }
    }
    
    func eventImage() -> UIImage {
        switch self {
        case .maintenance:
            return UIImage(systemName: "drop")!
        case .taxes:
            return UIImage(systemName: "banknote")!
        case .toll:
            return UIImage(systemName: "dollarsign.circle")!
        case .repairs:
            return UIImage(systemName: "wrench")!
        }
    }
     
}
