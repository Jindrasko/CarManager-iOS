//
//  NewEventView.swift
//  car_manager
//
//  Created by Jindra on 09.06.2022.
//

import SwiftUI
import MapKit
import CoreLocation

struct NewEventView: View {
    var vehicle: Vehicle
    var event: Event?
    
    @Binding var newEventPresented: Bool
    @State var showMap: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var done: Bool = false
    @State private var onceDate: Date = Date(timeIntervalSinceReferenceDate: -10000000)
    @State private var everyMonth: String = ""
    @State private var onceAtKm: String = ""
    @State private var everyKm: String = ""
    @State private var cost: String = ""
    @State private var eventCategory: EventCategory = EventCategory.maintenance
    @State private var location: String = ""
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var onceDateBool: Bool = false
    @State private var everyMonthBool: Bool = false
    @State private var onceAtKmBool: Bool = false
    @State private var everyKmBool: Bool = false
    
    
    func getCoordinates() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let coordinates = placemarks.first?.location
            else {
                return
            }
            
            self.latitude = coordinates.coordinate.latitude
            self.longitude = coordinates.coordinate.longitude
            
        }
    }
    
    private func loadEvent(){
        if(event != nil){
            title = event?.title ?? ""
            description = event?.longDescription ?? ""
            done = event?.done ?? false
            if(event?.onceDate != Date(timeIntervalSinceReferenceDate: -10000000)) { onceDateBool = true }
            onceDate = event?.onceDate ?? Date(timeIntervalSinceReferenceDate: -10000000)
            if(event?.everyMonth != 0) { everyMonthBool = true }
            everyMonth = event?.everyMonth.description ?? ""
            if(event?.onceAtKm != 0) { onceAtKmBool = true }
            onceAtKm = event?.onceAtKm.description ?? ""
            if(event?.everyKm != 0) { everyKmBool = true }
            everyKm = event?.everyKm.description ?? ""
            cost = event?.cost.description ?? ""
            eventCategory = event?.eventCategory ?? EventCategory.maintenance
            latitude = event?.latitude ?? 0
            longitude = event?.longitude ?? 0
            location = event?.location ?? ""
            
        }
    }
    
    private func saveEvent() {
        let newEvent: Event
        
        if(event == nil){
            newEvent = Event(context: viewContext)
        } else {
            newEvent = event!
        }
               
        getCoordinates()
        
        newEvent.title = title
        newEvent.longDescription = description
        newEvent.done = done
        
        if(!onceDateBool && everyMonthBool) {
            let now = Date()
            var dateComponent = DateComponents()
            dateComponent.month = Int(everyMonth)
            newEvent.onceDate = Calendar.current.date(byAdding: dateComponent, to: now)
            newEvent.everyMonth = Int32(everyMonth) ?? 0
        } else {
            if(onceDateBool){
                newEvent.onceDate = onceDate
            } else {
                newEvent.onceDate = Date(timeIntervalSinceReferenceDate: -10000000)
            }
            
            if(everyMonthBool){
                newEvent.everyMonth = Int32(everyMonth) ?? 0
            } else {
                newEvent.everyMonth = 0
            }
        }
        
        if(!onceAtKmBool && everyKmBool){
            newEvent.onceAtKm = (Int32(everyKm) ?? 0) + vehicle.mileage
            newEvent.everyKm = Int32(everyKm) ?? 0
        } else {
            if(onceAtKmBool){
                newEvent.onceAtKm = Int32(onceAtKm) ?? 0
            } else {
                newEvent.onceAtKm = 0
            }
                
            if(everyKmBool){
                newEvent.everyKm = Int32(everyKm) ?? 0
            } else {
                newEvent.everyKm = 0
            }
        }
        
        newEvent.cost = Double(cost) ?? 0.0
        newEvent.eventCategory = eventCategory
        newEvent.latitude = latitude
        newEvent.longitude = longitude
        newEvent.location = location
        newEvent.eventXVehicle = vehicle

        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    
    
    
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    
                    LabelTextField(labelText: "Title", textFieldText: $title)
                    LabelTextField(labelText: "Description", textFieldText: $description)
                    
                    Toggle("Event completed", isOn: $done)
                    
                    
                    HStack{
                        Text("Category: ")
                        Spacer()
                        Picker("Event Category", selection: $eventCategory){
                            ForEach(EventCategory.allCases, id: \.self) { event in
                                HStack{
                                    Image(uiImage: event.eventImage())
                                    Text(event.eventName()).tag(event)
                                }
                            }
                        }
                    }.padding(.top).padding(.bottom)
                    
                    Divider()
                    Group{
                        Toggle(isOn: $onceDateBool) {
                            DatePicker("Once:", selection: $onceDate, displayedComponents: .date).disabled(!onceDateBool)
                        }
                        
                        Toggle(isOn: $everyMonthBool){
                            Text("Every:")
                            Spacer()
                            TextField("0", text: $everyMonth).multilineTextAlignment(.trailing).disabled(!everyMonthBool)
                            Text("mon.")
                        }
                        
                        Toggle(isOn: $onceAtKmBool){
                            Text("Once at:")
                            Spacer()
                            TextField("0", text: $onceAtKm).multilineTextAlignment(.trailing).disabled(!onceAtKmBool)
                            Text("km")
                        }
                        
                        Toggle(isOn: $everyKmBool){
                            Text("Every:")
                            Spacer()
                            TextField("0", text: $everyKm).multilineTextAlignment(.trailing).disabled(!everyKmBool)
                            Text("km")
                        }
                    }
                    Divider()
                    
                    LabelTextField(labelText: "Cost", textFieldText: $cost)
                    
                    HStack{
                    
                        LabelTextField(labelText: "Location", textFieldText: $location)
                        
                        Button(action: {
                            getCoordinates()
                            print(latitude)
                            print(longitude)
                            showMap = true
                        }) {
                            Image(uiImage: UIImage(systemName: "mappin.and.ellipse")!)
                        }
                    }
                    
                    
                    
                }.padding()
            }
            .navigationTitle(event?.title ?? "New Event")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                self.loadEvent()
            }
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel"){
                        newEventPresented=false
                    }
                }
                                
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button(action: {
                        saveEvent()
                        newEventPresented = false
                    }){
                        Text("Save")
                    }
                }
            }
            .sheet(isPresented: $showMap){
                MapEditView(latitude: latitude, longitude: longitude, showMap: $showMap, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                    )
                )
            }
        }
    }
}

