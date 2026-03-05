//
//  VehicleDetail.swift
//  car_manager
//
//  Created by Jindra on 25.05.2022.
//

import SwiftUI

struct VehicleDetail: View {
    var vehicle: Vehicle
    
    @State var newVehiclePresented = false
    
    var body: some View {
        ScrollView{
            VStack{
                if (vehicle.image != nil){
                    Image(uiImage: UIImage(data: vehicle.image!)!)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 250, alignment: .center)
                }
                
                Text("\(vehicle.manufacturer ?? " ") \(vehicle.model ?? " ") \(String(vehicle.yearOfManufacture))")
                
                if(vehicle.mileage != 0) {
                    Text("Mileage: \(vehicle.mileage)")
                }
                
                if(vehicle.licencePlate != "") {
                    Text("Licence plate: \(vehicle.licencePlate ?? " ")")
                }
                
                if(vehicle.dateOfPurchase != nil) {
                    Text("Date of purchase: \(dateFormatter.string(from: vehicle.dateOfPurchase!))")
                }
                
                Text("Fuel Type: \(vehicle.fuelType.typeName())")
                
                if(vehicle.color != "") {
                    Text("Color: \(vehicle.color!)")
                }
                
                if(vehicle.vin != ""){
                    Text("VIN: \(vehicle.vin!)")
                }
                
                
                
                
            }
            .navigationTitle(vehicle.title ?? vehicle.model ?? "No title")
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        newVehiclePresented = true
                    }) {
                        Text("Edit")
                    }
                    
                }
            }
            .sheet(isPresented: $newVehiclePresented){
                NewVehicleView(vehicle: vehicle, newVehiclePresented: $newVehiclePresented)
            }

        }
    }
}

struct VehicleDetail_Previews: PreviewProvider {
    static let vehicle = Vehicle()
    
    static var previews: some View {
        VehicleDetail(vehicle: vehicle)
    }
}
