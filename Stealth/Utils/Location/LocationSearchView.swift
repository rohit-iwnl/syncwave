//
//  LocationSearchView.swift
//  Stealth
//
//  Created by Rohit Manivel on 11/2/24.
//

import SwiftUI
import MapKit
import CoreLocation
import Combine

struct LocationSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedLocation: String
    @Binding var region: MKCoordinateRegion
    @State private var searchText: String = ""
    @State private var tempSelectedLocation: String = ""
    @State private var showConfirmButton: Bool = false
    @State private var selectedAnnotation: MKPointAnnotation? // Add this line
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    ))

    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var searchCompleter = SearchCompleter()
    
    // Add these new state properties
    @State private var isLoadingCurrentLocation = false
    @State private var nearbyLocations: [MKMapItem] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Enter Property Location")
                .font(.sora(.title2, weight: .bold))
                .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
            
            // Add Current Location Button
            Button(action: useCurrentLocation) {
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 16))
                    Text("Use Current Location")
                        .font(.sora(.body))
                        .foregroundColor(.white)
                    if isLoadingCurrentLocation {
                        Spacer()
                        ProgressView()
                            .tint(.white)
                    }
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .cornerRadius(12)
            }
            .padding(.horizontal)
            
            TextField("Search location", text: $searchText)
                .font(.sora(.body, weight: .regular))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onChange(of: searchText) { _, newValue in
                    searchCompleter.searchTerm = newValue
                }
            
            // Show nearby locations when search is empty
            if searchText.isEmpty && !nearbyLocations.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nearby Locations")
                            .font(.sora(.subheadline, weight: .medium))
                            .padding(.horizontal)
                        
                        ForEach(nearbyLocations, id: \.self) { item in
                            LocationResultRow(
                                title: item.name ?? "",
                                subtitle: item.placemark.formattedAddress ?? ""
                            )
                            .onTapGesture {
                                selectMapItem(item)
                            }
                            Divider()
                        }
                    }
                }
            }
            
            if showConfirmButton {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Selected Location:")
                        .font(.sora(.subheadline, weight: .medium))
                    Text(tempSelectedLocation)
                        .font(.sora(.body))
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        selectedLocation = tempSelectedLocation
                        dismiss()
                    }) {
                        HStack {
                            Spacer()
                            Text("Confirm Location")
                                .font(.sora(.body, weight: .medium))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
            
            // Search Results
            if !searchCompleter.completions.isEmpty {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(searchCompleter.completions, id: \.self) { completion in
                            LocationResultRow(
                                title: completion.title,
                                subtitle: completion.subtitle
                            )
                            .onTapGesture {
                                selectLocation(completion)
                            }
                            Divider()
                        }
                    }
                }
                .background(Color.white)
            }
//            Map(position: $cameraPosition) {
//                if let annotation = selectedAnnotation {
//                    Annotation("Selected Location", coordinate: annotation.coordinate) {
//                        Image(systemName: "mappin.circle.fill")
//                            .foregroundStyle(.red)
//                            .font(.title2)
//                            .padding(8)
//                            .background(.white)
//                            .clipShape(Circle())
//                    }
//                }
//            }
//            .mapStyle(.standard(elevation: .realistic))
//            .frame(height: 200)
//            .cornerRadius(12)
//            .padding(.horizontal)
            
            Spacer()
            
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
        .onAppear {
            locationManager.requestLocationPermission()
            fetchNearbyLocations()
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
    
    private func selectLocation(_ completion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else { return }
            
            DispatchQueue.main.async {
                // Create annotation for selected location
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = completion.title
                self.selectedAnnotation = annotation
                
                // Update camera position with animation
                withAnimation {
                    self.cameraPosition = .region(MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ))
                }
                
                // Update region for binding
                self.region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
                
                // Update the temporary selected location
                if let placemark = response?.mapItems.first?.placemark {
                    let address = [
                        placemark.subThoroughfare,
                        placemark.thoroughfare,
                        placemark.locality,
                        placemark.administrativeArea,
                        placemark.postalCode
                    ].compactMap { $0 }.joined(separator: " ")
                    
                    self.tempSelectedLocation = address
                    self.showConfirmButton = true
                }
            }
        }
    }
    
    // Add these new methods
    private func useCurrentLocation() {
        isLoadingCurrentLocation = true
        
        guard let location = locationManager.userLocation else {
            locationManager.requestLocationPermission()
            isLoadingCurrentLocation = false
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            DispatchQueue.main.async {
                isLoadingCurrentLocation = false
                
                if let placemark = placemarks?.first {
                    let address = [
                        placemark.subThoroughfare,
                        placemark.thoroughfare,
                        placemark.locality,
                        placemark.administrativeArea,
                        placemark.postalCode
                    ].compactMap { $0 }.joined(separator: " ")
                    
                    tempSelectedLocation = address
                    showConfirmButton = true
                    region = MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                }
            }
        }
    }
    
    private func fetchNearbyLocations() {
        guard let location = locationManager.userLocation else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "point of interest"
        request.region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else { return }
            
            DispatchQueue.main.async {
                self.nearbyLocations = response.mapItems
            }
        }
    }
    
    private func selectMapItem(_ mapItem: MKMapItem) {
        let coordinate = mapItem.placemark.coordinate
        
        DispatchQueue.main.async {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = mapItem.name
            self.selectedAnnotation = annotation
            
            withAnimation {
                self.cameraPosition = .region(MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ))
            }
            
            self.region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            
            self.tempSelectedLocation = mapItem.placemark.formattedAddress ?? ""
            self.showConfirmButton = true
        }
    }
}

// Add this extension to MKPlacemark
extension MKPlacemark {
    var formattedAddress: String? {
        let addressComponents = [
            subThoroughfare,
            thoroughfare,
            locality,
            administrativeArea,
            postalCode
        ].compactMap { $0 }
        
        return addressComponents.isEmpty ? nil : addressComponents.joined(separator: " ")
    }
}

// Location Manager class to handle permissions and updates
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            authorizationStatus = manager.authorizationStatus
        case .denied, .restricted:
            authorizationStatus = manager.authorizationStatus
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            authorizationStatus = manager.authorizationStatus
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
    }
}

// Search Completer class (same as before)
class SearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchTerm = ""
    @Published var completions: [MKLocalSearchCompletion] = []
    private var completer: MKLocalSearchCompleter
    private var cancellable: AnyCancellable?
    
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        completer.delegate = self
        completer.resultTypes = [.address, .pointOfInterest]
        
        // Set up the publisher for search term changes
        cancellable = $searchTerm
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
            .sink { [weak self] term in
                if term.isEmpty {
                    self?.completions = []
                } else {
                    self?.completer.queryFragment = term
                }
            }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.completions = completer.results
            print("Found \(self.completions.count) completions")
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}


struct LocationResultRow: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.gray)
                Text(title)
                    .font(.system(.body))
                Spacer()
            }
            
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.system(.caption))
                    .foregroundColor(.gray)
                    .padding(.leading, 28)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .contentShape(Rectangle())
    }
}

struct LocationDetails: Equatable {
    var name: String
    var latitude: Double
    var longitude: Double
    var regionLatDelta: Double
    var regionLongDelta: Double
    
    static func == (lhs: LocationDetails, rhs: LocationDetails) -> Bool {
        return lhs.name == rhs.name &&
               lhs.latitude == rhs.latitude &&
               lhs.longitude == rhs.longitude &&
               lhs.regionLatDelta == rhs.regionLatDelta &&
               lhs.regionLongDelta == rhs.regionLongDelta
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: regionLatDelta,
                longitudeDelta: regionLongDelta
            )
        )
    }
}


#Preview {
    LocationSearchView(selectedLocation: .constant("University Park"), region: .constant(
        MKCoordinateRegion(
            
            center: CLLocationCoordinate2D(latitude: 34.0224, longitude: -118.2851),
            
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            
    )))
}
