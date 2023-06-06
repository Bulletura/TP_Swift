//
//  MapView.swift
//  App_Swift
//
//  Created by digital on 22/05/2023.
//

import SwiftUI
import MapKit


struct ParentMapView: View {
    @State private var places: [Place] = []
    
    var body: some View {
        MapView(annotations: $places)
            .task {
                search()
            }
    }
    
    
    func search() -> Void {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.resultTypes = .pointOfInterest
        searchRequest.region.center = CLLocationCoordinate2D(latitude: 45.9074295, longitude: 6.1020281)
//        searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: [.movieTheater])
        searchRequest.naturalLanguageQuery = "cinema"
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            Task { @MainActor in
                self.places = response.mapItems.map {
                    .init(name: $0.name ?? "--", coordinate: $0.placemark.coordinate)
                }
            }
        }
    }
}


struct MapView: View {
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45.9074295, longitude: 6.1020281), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @State private var mapManager = GPSManager()
    @State private var showPOI: Bool = false
    @State private var selectedPOI: Place?
    @Binding var annotations: [Place]
    
    var body: some View {
        let _ = Self._printChanges()
        
        Map(coordinateRegion: $mapRegion,
            showsUserLocation: true,
            annotationItems: annotations
        ){ annot in
            MapMarker(coordinate: annot.coordinate)

//            MapAnnotation(coordinate: place.coordinate, content: {
//                Button {
////                    showPOI.toggle()
////                    selectedPOI = place
//                } label: {
//                    Image(systemName: "mappin.circle.fill")
//                }
//            })
        }
        .onAppear(){
            mapManager.authorize()
        }.edgesIgnoringSafeArea(.all)
            .navigationDestination(isPresented: $showPOI, destination: {
                if let place = selectedPOI {
                    Text(place.name)
                }
            })
        
    }
}

class GPSManager: NSObject, ObservableObject {
    private var mapManager = CLLocationManager()
    override init() {
        super.init()
        mapManager.delegate = self
    }
    func authorize(){
        mapManager.requestWhenInUseAuthorization()
    }
}

extension GPSManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }
}
