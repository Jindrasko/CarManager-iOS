//
//  MapView.swift
//  car_manager
//
//  Created by Jindra on 11.06.2022.
//

import SwiftUI
import MapKit


struct AnnotatedItem: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct MapEditView: View {
    var latitude: Double
    var longitude: Double
    
    @Binding var showMap: Bool

    @State var region: MKCoordinateRegion
    @State private var mapType: MKMapType = .standard
    @State private var trackingMode = MapUserTrackingMode.follow
    
    
    var body: some View {
        NavigationView{
            VStack{
                Map(coordinateRegion: $region,
                    interactionModes: .all, //.all .pan .zoom
                    showsUserLocation: true,
                    userTrackingMode: $trackingMode, annotationItems: [AnnotatedItem(name: "Pin", coordinate: .init(latitude: latitude , longitude: longitude ))]) { item in
                    MapPin(coordinate: item.coordinate, tint: .red)
                }
            }.padding()
            
                .navigationTitle("Location")
                .toolbar{
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Cancel"){
                            showMap = false
                        }
                    }
                }
        }
        
    }
}
      

//struct MapEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapEditView(region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 10, longitude: 18.8), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
//    }
//}
