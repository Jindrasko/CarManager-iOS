//
//  EventRow.swift
//  car_manager
//
//  Created by Jindra on 08.06.2022.
//

import SwiftUI

struct EventRow: View {
    var event: Event
    
    private func getInterval() -> String {
        var text: String = ""
        
        if(event.onceDate != Date(timeIntervalSinceReferenceDate: -10000000) && event.onceAtKm == 0){
            let diff = Calendar.current.dateComponents([.day], from: Date(), to: event.onceDate!).day!
            text = "in \(diff) days"
        } else if(event.onceDate == Date(timeIntervalSinceReferenceDate: -10000000) && event.onceAtKm != 0){
            let diff = event.onceAtKm - event.eventXVehicle!.mileage
            text = "in \(diff) km"
        } else {
            let dateDiff = Calendar.current.dateComponents([.day], from: Date(), to: event.onceDate!).day!
            let kmDiff = event.onceAtKm - event.eventXVehicle!.mileage
            
            if(dateDiff*40 < kmDiff) {
                text = "in \(dateDiff) days"
            } else {
                text = "in \(kmDiff) km"
            }
        }
        
        return text
    }
    
    
    var body: some View {
        HStack{
            
            Image(uiImage: event.eventCategory.eventImage())
            
            VStack(alignment: .leading){
                Text(event.title ?? "No title")
                if(event.done == true) {
                    Text("Completed").foregroundColor(.green)
                } else {
                    Text(getInterval())
                }
            }.padding(.leading, 8)
        }.padding(2)
    }
}



struct EventRow_Previews: PreviewProvider {
    static var event = Event()
    
    static var previews: some View {
        EventRow(event: event)
    }
}
