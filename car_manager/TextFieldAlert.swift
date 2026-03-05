//
//  TextFieldAlert.swift
//  car_manager
//
//  Created by Jindra on 14.06.2022.
//

import SwiftUI

struct TextFieldAlert<Presenting>: View where Presenting: View {
    var vehicle: Vehicle
    
    @Binding var isShowing: Bool
    @State var text: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    
    let presenting: Presenting
    let title: String
    
    private func saveMileage() {
        if(text != "") {
            vehicle.mileage = Int32(text) ?? 0
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                VStack {
                    Text(self.title)
                    TextField("",text: self.$text)
                    Divider()
                    HStack {
                        Button(action: {
                            saveMileage()
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("Save")
                            
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height*0.7
                )
                .shadow(radius: 1)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }

}



extension View {

    func textFieldAlert(isShowing: Binding<Bool>,
                        vehicle: Vehicle,
                        title: String) -> some View {
        TextFieldAlert(vehicle: vehicle,
                        isShowing: isShowing,
                       presenting: self,
                       title: title)
    }

}
