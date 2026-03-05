//
//  car_managerApp.swift
//  car_manager
//
//  Created by Jindra on 13.05.2022.
//

import SwiftUI

@main
struct car_managerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
