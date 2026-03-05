//
//  EventList.swift
//  car_manager
//
//  Created by Jindra on 08.06.2022.
//

import SwiftUI

struct EventList: View {
    var vehicle: Vehicle
    
    @State var newEventPresented = false
    @State var showAlert = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Event.done, ascending: false), NSSortDescriptor(keyPath: \Event.title, ascending: true)],
        animation: .default)
    private var events: FetchedResults<Event>
    
    private func getChartValues() -> [Double] {
        var values: [Double] = [0.0,0.0,0.0,0.0]
        
        for event in events {
            if(event.done == true){
                switch event.eventCategory {
                    case .maintenance:
                        values[0] = values[0] + event.cost
                    case .taxes:
                        values[1] = values[1] + event.cost
                    case .toll:
                        values[2] = values[2] + event.cost
                    case .repairs:
                        values[3] = values[3] + event.cost
                }
            }
        }
        
        return values
    }
    
    private func sortEvents(e1: Event, e2: Event) -> Bool {
        var e1Value : Int32 = 999999999
        var e2Value : Int32 = 999999999
        
        if(e1.done == true && e2.done == true){
            return true
        }else if(e1.done == false && e2.done == true){
            return false
        } else if (e1.done == true && e2.done == false){
            return true
        }
        
        if(e1.onceDate !=  Date(timeIntervalSinceReferenceDate: -10000000)){
            e1Value = Int32(Calendar.current.dateComponents([.day], from: Date(), to: e1.onceDate!).day!) * 40
        }
        
        if(e2.onceDate !=  Date(timeIntervalSinceReferenceDate: -10000000)){
            e2Value = Int32(Calendar.current.dateComponents([.day], from: Date(), to: e2.onceDate!).day!) * 40
        }
        
        if(e1.onceAtKm != 0){
            if(e1.onceAtKm - e1.eventXVehicle!.mileage < e1Value){
                e1Value = e1.onceAtKm - e1.eventXVehicle!.mileage
            }
        }
        
        if(e2.onceAtKm != 0){
            if(e2.onceAtKm - e2.eventXVehicle!.mileage < e2Value){
                e2Value = e2.onceAtKm - e2.eventXVehicle!.mileage
            }
        }
        
        if(e1Value == 999999999){
            e1Value = 0
        }
        
        if(e2Value == 999999999){
            e2Value = 0
        }
        
        return e1Value < e2Value
    }
    
    var body: some View {
        VStack{
            List{
                ForEach(events.sorted(by: sortEvents)){ event in
                    if(event.eventXVehicle == vehicle){
                        NavigationLink {
                            EventDetail(vehicle: vehicle ,event: event)
                        } label: {
                            EventRow(event: event)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
        }.navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    if(getChartValues() != [0,0,0,0]) {
                        NavigationLink {
                            ChartView(values: getChartValues())
                        } label: {
                            Label("Chart",systemImage: "chart.pie")
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        showAlert = true
                    }) {
                        Label("Set mileage",systemImage: "gauge")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        newEventPresented = true
                    }) {
                        Label("Add Event",systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
            }
            .sheet(isPresented: $newEventPresented){
                NewEventView(vehicle: vehicle ,newEventPresented: $newEventPresented)
            }
            .textFieldAlert(isShowing: $showAlert, vehicle: vehicle, title: "Set mileage:")
        
    }
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { events[$0] }.forEach(viewContext.delete)

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




struct EventList_Previews: PreviewProvider {
    static let vehicle = Vehicle()
    
    static var previews: some View {
        EventList(vehicle: vehicle)
    }
}
