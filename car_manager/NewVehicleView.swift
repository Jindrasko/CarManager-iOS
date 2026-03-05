//
//  NewCarView.swift
//  car_manager
//
//  Created by Jindra on 25.05.2022.
//

import SwiftUI

struct NewVehicleView: View {
    var vehicle: Vehicle?
    
    @Binding var newVehiclePresented: Bool
    @State var showImageSheet: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var title: String = "Vehicle"
    @State private var manufacturer: String = ""
    @State private var model: String = ""
    @State private var licencePlate: String = ""
    @State private var yearOfManufacture: String = ""
    @State private var mileage: String = ""
    @State private var vin: String = ""
    @State private var color: String = ""
    @State private var date: Date = Date(timeIntervalSinceReferenceDate: -10000000)
    @State private var image = UIImage()
    @State private var fuelType: FuelType = FuelType.gasoline
    
    private func loadVehicle(){
        if(vehicle != nil){
            title = vehicle?.title ?? ""
            manufacturer = vehicle?.manufacturer ?? ""
            model = vehicle?.model ?? ""
            licencePlate = vehicle?.licencePlate ?? ""
            yearOfManufacture = vehicle?.yearOfManufacture.description ?? ""
            mileage = vehicle?.mileage.description ?? ""
            vin = vehicle?.vin ?? ""
            color = vehicle?.color ?? ""
            date = vehicle?.dateOfPurchase ?? Date(timeIntervalSinceReferenceDate: -10000000)
            image = UIImage(data: (vehicle?.image)!) ?? UIImage()
            fuelType = vehicle?.fuelType ?? FuelType.gasoline
        }
    }
    
    private func saveVehicle(){
        let jpegImageData = image.jpegData(compressionQuality: 1.0)
        var newVehicle: Vehicle
        
        if(vehicle == nil) {
            newVehicle = Vehicle(context: viewContext)
        } else {
            newVehicle = vehicle!
        }
        
        newVehicle.title = title
        newVehicle.manufacturer = manufacturer
        newVehicle.model = model
        newVehicle.licencePlate = licencePlate
        newVehicle.mileage = Int32(mileage) ?? 0
        newVehicle.yearOfManufacture = Int16(yearOfManufacture) ?? 0
        newVehicle.vin = vin
        newVehicle.color = color
        if(date != Date(timeIntervalSinceReferenceDate: -10000000)){
            newVehicle.dateOfPurchase = date
        }
        newVehicle.setValue(jpegImageData, forKey: "image")
        newVehicle.fuelType = fuelType
        
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
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100, alignment: .center)
                    
                    Button(action: {
                        showImageSheet = true
                    }) {
                        HStack{
                            Image(systemName: "camera")
                            Text("Change photo")
                        }
                    }
                    Group{
                        LabelTextField(labelText: "Title", textFieldText: $title)
                        LabelTextField(labelText: "Manufacturer", textFieldText: $manufacturer)
                        LabelTextField(labelText: "Model", textFieldText: $model)
                        LabelTextField(labelText: "Mileage", textFieldText: $mileage)
                        HStack{
                            LabelTextField(labelText: "Licence plate", textFieldText: $licencePlate)
                            LabelTextField(labelText: "Year of manufacture", textFieldText: $yearOfManufacture)
                        }
                    }
                    HStack{
                        Text("Fuel type: ")
                        Spacer()
                        Picker("Fuel type", selection: $fuelType){
                            ForEach(FuelType.allCases, id: \.self) { type in
                                let value = type.typeName()
                                Text(value).tag(type)
                            }
                        }
                    }
                    
                    LabelTextField(labelText: "VIN", textFieldText: $vin)
                    LabelTextField(labelText: "Color", textFieldText: $color)
                  
                    DatePicker("Date of purchase", selection: $date, displayedComponents: .date)
                    
                    
                }.padding()
            }
            .onAppear {
                self.loadVehicle()
            }
            .navigationTitle(vehicle?.title ?? "New Vehicle")
            .navigationBarTitleDisplayMode(.inline)

            .sheet(isPresented: $showImageSheet) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel"){
                        newVehiclePresented=false
                    }
                }
                                
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button(action: {
                        saveVehicle()
                        newVehiclePresented = false
                    }){
                        Text("Save")
                    }
                }
                                
            }
            
        }
    }
}

struct NewVehicleView_Previews: PreviewProvider {
    static var vehicle = Vehicle()
    
    static var previews: some View {
        NewVehicleView(vehicle: vehicle ,newVehiclePresented: .constant(true))
    }
}

