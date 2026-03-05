//
//  MapView.swift
//  car_manager
//
//  Created by Jindra on 11.06.2022.
//

import SwiftUI
import MapKit

struct MapView: View {
    var event: Event
    
    @State var region: MKCoordinateRegion
    @State private var mapType: MKMapType = .standard
    @State private var trackingMode = MapUserTrackingMode.follow
    
    struct AnnotatedItem: Identifiable {
        let id = UUID()
        var name: String
        var coordinate: CLLocationCoordinate2D
    }
    
    var body: some View {
        
        Map(coordinateRegion: $region,
            interactionModes: .all, //.all .pan .zoom
            showsUserLocation: true,
            userTrackingMode: $trackingMode, annotationItems: [AnnotatedItem(name: "Pin", coordinate: .init(latitude: event.latitude , longitude: event.longitude ))]) { item in
            MapPin(coordinate: item.coordinate, tint: .red)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static let event = Event()
    
    static var previews: some View {
        MapView(event: event, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 10, longitude: 18.8), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
    }
}
