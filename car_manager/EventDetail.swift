//
//  EventDetail.swift
//  car_manager
//
//  Created by Jindra on 11.06.2022.
//

import SwiftUI
import MapKit

struct EventDetail: View {
    var vehicle: Vehicle
    var event: Event
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var newEventPresented = false

    private func completeEvent(){
        
        event.done = true
        if(event.everyMonth != 0 || event.everyKm != 0){
            
            let newEvent = Event(context: viewContext)
            
            newEvent.title = event.title
            newEvent.longDescription = event.longDescription
            newEvent.done = false
            newEvent.onceDate = event.onceDate
            newEvent.everyMonth = Int32(event.everyMonth)
            newEvent.onceAtKm = Int32(event.onceAtKm)
            newEvent.everyKm = Int32(event.everyKm)
            newEvent.cost = Double(event.cost)
            newEvent.eventCategory = event.eventCategory
            newEvent.latitude = event.latitude
            newEvent.longitude = event.longitude
            newEvent.location = event.location
            newEvent.eventXVehicle = event.eventXVehicle
            
            if(event.everyMonth != 0){
                let now = Date()
                var dateComponent = DateComponents()
                dateComponent.month = Int(event.everyMonth)
                
                newEvent.onceDate = Calendar.current.date(byAdding: dateComponent, to: now)
            }
                
            if(event.everyKm != 0) {
                newEvent.onceAtKm = (event.eventXVehicle?.mileage ?? 0) + event.everyKm
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
    
    var body: some View {
        ScrollView{
            VStack{
                
                HStack{
                    Text("Category: ")
                    Image(uiImage: event.eventCategory.eventImage())
                    Text(event.eventCategory.eventName())
                }
                
                if(event.longDescription != "") {
                    VStack(alignment: .leading) {
                        Text("Description:")
                        Text(event.longDescription!)
                    }
                }
                
                Group{
                    
                    Divider()
                    
                    Text("Periodicity").multilineTextAlignment(.leading)
                    
                    if(event.onceDate != Date(timeIntervalSinceReferenceDate: -10000000)){
                        HStack{
                            Text("Once: ")
                            Spacer()
                            Text(dateFormatter.string(from: event.onceDate!))
                        }
                    }
                    
                    if(event.everyMonth != 0){
                        HStack{
                            Text("Every:")
                            Spacer()
                            Text("\(event.everyMonth) mon.")
                        }
                    }
                    
                    if(event.onceAtKm != 0) {
                        HStack{
                            Text("Once at:")
                            Spacer()
                            Text("\(event.onceAtKm) Km")
                        }
                    }
                    
                    if(event.everyKm != 0) {
                        HStack{
                            Text("Every: ")
                            Spacer()
                            Text("\(event.everyKm)")
                        }
                    }
                        
                    Divider()
                }
                
                HStack{
                    Text("Cost: ")
                    Spacer()
                    Text("\(event.cost) $")
                }
                
                if(event.location != ""){
                    HStack{
                        Text("Location: ")
                        Spacer()
                        Text(event.location ?? "")
                    }.padding(.top)
                
                
                //Text("\(event.latitude)")
                //Text("\(event.longitude)")
         
                MapView(event: event, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: event.latitude , longitude: event.longitude ), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
                    .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 300, alignment: .center)
                    .padding()
                }
                
                if(!event.done){
                    Button(action: {
                        completeEvent()
                    }) {
                        Text("Complete event")
                    }.padding()
                
                }
                
                
            }.padding()
            .navigationTitle(event.title ?? "No title")
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        newEventPresented = true
                    }) {
                        Text("Edit")
                    }
                    
                }
            }
            .sheet(isPresented: $newEventPresented){
                NewEventView(vehicle: vehicle, event: event, newEventPresented: $newEventPresented)
            }
            
            
        }
    }
}

struct EventDetail_Previews: PreviewProvider {
    static let vehicle = Vehicle()
    static let event = Event()
    
    static var previews: some View {
        EventDetail(vehicle: vehicle, event: event)
    }
}
