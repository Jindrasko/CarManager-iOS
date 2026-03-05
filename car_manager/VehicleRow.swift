//
//  VehicleRow.swift
//  car_manager
//
//  Created by Jindra on 16.05.2022.
//

import SwiftUI

struct VehicleRow: View {
    var vehicle: Vehicle
    
    @State private var action: Int? = 0
    
    var body: some View {
        VStack{
            
            NavigationLink (destination: VehicleDetail(vehicle: vehicle), tag: 1, selection: $action) {
                EmptyView()
            }.opacity(0)
            
            
            HStack{
                if (vehicle.image != nil){
                    Image(uiImage: UIImage(data: vehicle.image!)!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50, alignment: .center)
                }
                Text(vehicle.title ?? "No title").padding()
                
                Spacer()
                
                
                
                Label("Vehicle info", systemImage: "info.circle").labelStyle(.iconOnly).onTapGesture {
                    self.action = 1
                }
                
                
                /*
                NavigationLink {
                    VehicleDetail(vehicle: vehicle)
                } label: {
                    Label("Vehicle info", systemImage: "info.circle.fill").labelStyle(.iconOnly)
                }
                */
            }
        }
        
        
    }
}



struct VehicleRow_Previews: PreviewProvider {
    static let vehicle = Vehicle()
    
    static var previews: some View {
        VehicleRow(vehicle: vehicle)
    }
}

