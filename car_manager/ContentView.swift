//
//  ContentView.swift
//  car_manager
//
//  Created by Jindra on 13.05.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var newVehiclePresented = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Vehicle.title, ascending: true)],
        animation: .default)
    private var vehicles: FetchedResults<Vehicle>

    var body: some View {
        NavigationView {
            List {
                ForEach(vehicles) { vehicle in
                    NavigationLink {
                        EventList(vehicle: vehicle)
                    } label: {
                        VehicleRow(vehicle: vehicle)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        newVehiclePresented = true
                    }) {
                        Label("Add vehicle",systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Vehicles")
            .sheet(isPresented: $newVehiclePresented){
                NewVehicleView(vehicle: nil, newVehiclePresented: $newVehiclePresented)
            }
        }
    }


    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { vehicles[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

public let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
