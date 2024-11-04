import SwiftUI
import MapKit
import CoreLocation

struct LeasingView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var selectedHouseOptions: [Int: Bool] = [:]
    @State private var isLoading: Bool = false
    @State private var selectedBedrooms : Set<String> = []
    @State private var selectedBathrooms : Set<String> = []
    @State private var selectedNumberOfRoommates : Set<String> = []
    @State private var selectedFurnishing : Set<String> = []
    @State private var selectedAmenities : Set<String> = []

    
    @EnvironmentObject var appUserStateManager: AppUserManger
    
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showSkipAlert = false
    
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var monthlyBaseRentAmount: Int = 0
    
    @State private var perPersonRent: Int = 0
    @State private var squareFootage: Int = 0
    
    @State private var showLocationSearch = false
    @State private var selectedLocation = ""

    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var propertyDescription: String = ""
    
    
    
    var body: some View {
        VStack {
            // Main HousingPreferencesView content
            GeometryReader { geometry in
                ZStack {
                    ScrollView {
                        VStack{
                            PreferencesToolbar(currentPage: $navigationCoordinator.currentPage, totalPages: $navigationCoordinator.totalPages, showPages: .constant(true), onBackTap: handleBackTap) {
                                showSkipAlert = true
                            }
                            
                            VStack(alignment: .leading, spacing: 20) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Got a space? Spill the tea and let’s lease/ sublease it!")
                                        .font(.sora(.largeTitle, weight: .semibold))
                                        .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                        .lineLimit(3)
                                    Text("Share the deets about your property! What makes it special?")
                                        .font(.sora(.callout, weight: .regular))
                                        .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                        .lineLimit(2)
                                        .foregroundStyle(.gray)
                                }
                                
                                Text("Type of unit?")
                                    .font(.sora(.callout, weight: .regular))
                                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                    .lineLimit(2)
                                    .foregroundStyle(TextColors.primaryBlack.color)
                                
                                LazyVGrid(columns: adaptiveGridColumns(for: geometry.size.width), spacing: 16) {
                                    ForEach(HousingViewConstants.houseOptionButtons.indices, id: \.self) { index in
                                        let button = HousingViewConstants.houseOptionButtons[index]
                                        Button {
                                            toggleSelection(index)
                                        } label: {
                                            ZStack(alignment: .bottomTrailing) {
                                                VStack(alignment: .leading) {
                                                    Text(button.label)
                                                        .font(.sora(.headline))
                                                        .foregroundColor(.black)
                                                        .padding()
                                                    Spacer(minLength: 20)
                                                    HStack {
                                                        Spacer()
                                                        Image("Preferences/Housing/\(button.illustration)")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: geometry.size.width / 4, height: geometry.size.width / 4)
                                                            .scaleEffect(selectedHouseOptions[index] ?? false ? 1.2 : 1.0)
                                                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedHouseOptions[index] ?? false)
                                                            .padding(.bottom)
                                                        Spacer()
                                                    }
                                                }
                                                .frame(maxWidth: .infinity, minHeight: geometry.size.height * 0.15, alignment: .topLeading)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(selectedHouseOptions[index] ?? false ? button.pressableColor : button.backgroundColor)
                                                )
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(selectedHouseOptions[index] ?? false ? Color.black : Color.gray.opacity(0.2), lineWidth: selectedHouseOptions[index] ?? false ? 1.2 : 1)
                                                )
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            }
                                        }
                                        .buttonStyle(PressableButtonStyle(
                                            backgroundColor: button.backgroundColor,
                                            pressedColor: button.pressableColor,
                                            isSelected: selectedHouseOptions[index] ?? false
                                        ))
                                        .sensoryFeedback(.selection, trigger: selectedHouseOptions[index] ?? false)
                                    }
                                }
                                
                                VStack(spacing: 10) {
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Property Location?")
                                            .font(.sora(.body))
                                            .padding(.vertical,4)
                                            .lineLimit(1)
                                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                        
                                        Button(action: {
                                            showLocationSearch = true
                                        }) {
                                            HStack {
                                                Text(selectedLocation.isEmpty ? "Click to add location" : selectedLocation)
                                                    .font(.sora(.body))
                                                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                                    .foregroundColor(selectedLocation.isEmpty ? .gray : .black)
                                                Spacer()
                                                Image(systemName: "magnifyingglass")
                                                    .foregroundColor(TextColors.primaryBlack.color)
                                            }
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.gray.opacity(0.3))
                                            )
                                        }
                                        if !selectedLocation.isEmpty {
                                            Map(initialPosition: .region(region)) {
                                                Annotation("Selected Location", coordinate: region.center) {
                                                    Image(systemName: "mappin.circle.fill")
                                                        .foregroundStyle(.red)
                                                        .font(.title)
                                                }
                                            }
                                            .mapStyle(.standard(elevation: .realistic))
                                            .frame(height: 200)
                                            .cornerRadius(12)
                                            .padding(.vertical)
                                        }
                                    }
                                    
                                    LabeledInputButton(label: "Monthly base rent of unit?", placeholder: "Enter your base rent", value: $monthlyBaseRentAmount, keyboardType: .numberPad, leftSideText: "$")
                                        .onChange(of: monthlyBaseRentAmount) { _ in
                                            updatePerPersonRent()
                                        }
                                    
                                    VStack(spacing : 5){
                                        HStack {
                                            Text("Preferred number of people per unit")
                                                .font(.sora(.body))
                                                .lineLimit(1)
                                                .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                            
                                            Spacer()
                                        }
                                        CustomSingleSelector(selectedOptions: $selectedNumberOfRoommates, options: LeasingOptions.roommateOptions, isScrollable: true, lineLimit: 1)
                                            .padding(.vertical)
                                            .onChange(of: selectedNumberOfRoommates) { _ in
                                                updatePerPersonRent()
                                            }
                                    }
                                    
                                    
                                    LabeledInputButton(label: "Monthly rent per person?", placeholder: "Enter the estimated amount", value: $perPersonRent, keyboardType: .numberPad, leftSideText: "$")
                                    
                                    LabeledInputButton(label: "Size of your unit?", placeholder: "Enter the sqaure footage", value: $squareFootage, keyboardType: .numberPad, leftSideText: "sqft")
                                    
                                    
                                    
                                }
                                VStack(spacing : 5){
                                    HStack {
                                        Text("Bedrooms")
                                            .font(.sora(.body))
                                            .lineLimit(1)
                                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                        
                                        Spacer()
                                    }
                                    CustomSingleSelector(selectedOptions: $selectedBedrooms, options: LeasingOptions.bedroomOptions, isScrollable: true, lineLimit: 1)
                                        .padding(.vertical)
                                }
                                
                                VStack(spacing : 5){
                                    HStack {
                                        Text("Bathrooms")
                                            .font(.sora(.body))
                                            .lineLimit(1)
                                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                        
                                        Spacer()
                                    }
                                    CustomSelector(selectedOptions: $selectedBathrooms, options: LeasingOptions.bathroomOptions, isScrollable: true, lineLimit: 1)
                                        .padding(.vertical)
                                }
                                
                                
                                
                                VStack(spacing : 5){
                                    HStack {
                                        Text("Furnishing")
                                            .font(.sora(.body))
                                            .lineLimit(1)
                                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                        
                                        Spacer()
                                    }
                                    CustomSelector(selectedOptions: $selectedFurnishing, options: LeasingOptions.furnishingOptions, isScrollable: true, lineLimit: 1)
                                        .padding(.vertical)
                                }
                                
                                
                                
                                HStack {
                                    Text("Amenities")
                                        .font(.sora(.body))
                                        .lineLimit(1)
                                        .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                    
                                    Spacer()
                                }
                                
                                
                                CustomSelectorAmenities(selectedOptions: $selectedAmenities, options: AmenitiesOptions.options)
                                
                                PropertyDescriptionInput(description: $propertyDescription, isEnabled: isSmartWriteEnabled())
                                
                                ContinueButton(
                                    isEnabled: checkIfValidSelection(),
                                    isLoading: isLoading
                                ) {
                                    Task{
                                        await performAPICallAndNavigate()
                                    }
                                }
                                .padding(.bottom, 20)
                            }
                            .padding()
                        }
                    }
                }
            }
            
            // Render RentRangePickerView when presented
        }
        .sheet(isPresented: $showLocationSearch) {
            LocationSearchView(selectedLocation: $selectedLocation, region: $region)
        }
        
        .alert(isPresented: $showSkipAlert) {
            Alert(
                title: Text("Skip Property preferences?"),
                message: Text("Skipping property preferences? You’ll get fewer spot-on recs. No stress though, you can update them later when finishing your profile!"),
                primaryButton: .default(Text("Yes, Skip")) {
                    handleSkip()
                },
                secondaryButton: .cancel()
            )
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        
    }
    
    private func handleSkip() {
        //        if navigationCoordinator.preferencesArray[JsonKey.find_roomate] == true {
        //            // Do something here
        //        } else {
        //            // Push home
        //        }
        
        navigationCoordinator.resetToHome()
    }
    
    private func getPropertyType() -> String {
        return selectedHouseOptions.compactMap { index, isSelected in
            guard isSelected else { return nil }
            switch index {
                case 0: return "condo"
                case 1: return "duplex"
                case 2: return "apartment"
                case 3: return "studio"
                default: return nil
            }
        }.first ?? ""
    }

    private func formatBedrooms() -> [String] {
        return Array(selectedBedrooms).map {
            $0.replacingOccurrences(of: "BR", with: "").trimmingCharacters(in: .whitespaces)
        }
    }

    private func getPropertyDetails() -> [String: Any] {
        return [
            "description": propertyDescription,
            "location": selectedLocation,
            "monthly_base_rent": monthlyBaseRentAmount,
            "per_person_rent": perPersonRent,
            "square_footage": squareFootage,
            "type": getPropertyType(),
            "bedrooms": formatBedrooms(),
            "bathrooms": Array(selectedBathrooms).map { $0.lowercased() },
            "preferred_roommates": Array(selectedNumberOfRoommates),
            "furnishing": Array(selectedFurnishing).map { $0.lowercased() },
            "amenities": Array(selectedAmenities)
        ]
    }

    private func getCoordinates() -> [String: Double] {
        return [
            "latitude": region.center.latitude,
            "longitude": region.center.longitude
        ]
    }

    private func convertToLeasingJSON() -> String {
        let preferences: [String: Any] = [
            "property": getPropertyDetails(),
            "coordinates": getCoordinates()
        ]
        
        do {
            let jsonData = try JSONSerialization.data(
                withJSONObject: preferences,
                options: [.prettyPrinted]
            )
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("JSON serialization error: \(error)")
        }
        
        return "{}"
    }


    
    
    private func handleBackTap() {
        withAnimation(.easeInOut(duration : 0.5)){
            if !navigationCoordinator.path.isEmpty {
                navigationCoordinator.path.removeLast()
                navigationCoordinator.currentPage -= 1
            } else {
                dismiss()
            }
        }
    }
    
    private func adaptiveGridColumns(for width: CGFloat) -> [GridItem] {
        let itemWidth: CGFloat = 150
        let numColumns = max(Int(width / itemWidth), 2)
        return Array(repeating: GridItem(.flexible(), spacing: 16), count: numColumns)
    }
    
    private func toggleSelection(_ buttonIndex: Int) {
        // Clear all selections first
        selectedHouseOptions.removeAll()
        // Set only the selected button to true
        selectedHouseOptions[buttonIndex] = true
    }
    
    private func isSmartWriteEnabled() -> Bool {
        return selectedHouseOptions.values.contains(true) && // Type of unit selected
               !selectedLocation.isEmpty && // Location is provided
               monthlyBaseRentAmount > 0 && // Base rent is entered
               !selectedBedrooms.isEmpty && // Bedrooms selected
               !selectedBathrooms.isEmpty && // Bathrooms selected
               !selectedNumberOfRoommates.isEmpty && // Number of roommates selected
               !selectedFurnishing.isEmpty && // Furnishing option selected
               !selectedAmenities.isEmpty && // At least one amenity selected
               squareFootage > 0 // Square footage entered
    }
    
    
    private func checkIfValidSelection() -> Bool {
        // Check all required fields
        return selectedHouseOptions.values.contains(true) && // Type of unit selected
               !selectedLocation.isEmpty && // Location is provided
               monthlyBaseRentAmount > 0 && // Base rent is entered
               !selectedBedrooms.isEmpty && // Bedrooms selected
               !selectedBathrooms.isEmpty && // Bathrooms selected
               !selectedNumberOfRoommates.isEmpty && // Number of roommates selected
               !selectedFurnishing.isEmpty && // Furnishing option selected
               !selectedAmenities.isEmpty && // At least one amenity selected
               !propertyDescription.isEmpty && // Property description provided
               squareFootage > 0 // Square footage entered
    }

    
    
    private func performAPICallAndNavigate() async {
        isLoading = true
        
        guard let supabaseId = try? await AuthManager.shared.getCurrentSession(),
              let userId = supabaseId.uid else {
            print("Error: No user ID found")
            isLoading = false
            return
        }
        
        
        // Convert preferences to JSON
        let jsonBody = convertToLeasingJSON()
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: [.prettyPrinted])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Housing Preferences JSON:")
                print(jsonString)
            }
        } catch {
            print("JSON serialization error: \(error)")
            isLoading = false
            return
        }
        
        
//        guard let url = URL(string: "http://159.89.222.41:8000/api/onboarding/set-housing-preferences") else {
//            print("Invalid URL")
//            isLoading = false
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer Naandhaandaungoppan", forHTTPHeaderField: "Authorization")
        
        // Add try keyword here since JSONSerialization.data can throw
        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
//
//            // Make API call
//            Task {
//                do {
//                    let (_data, response) = try await URLSession.shared.data(for: request)
//
//                    guard let httpResponse = response as? HTTPURLResponse else {
//                        throw URLError(.badServerResponse)
//                    }
//
//                    // Check status code
//                    guard 200...299 ~= httpResponse.statusCode else {
//                        throw URLError(.badServerResponse)
//                    }
//
//                    // Try to decode response if needed
//                    // let decodedResponse = try JSONDecoder().decode(YourResponseType.self, from: data)
//
//                    await MainActor.run {
//                        isLoading = false
//                        self.navigationCoordinator.resetToHome()
//                    }
//
//                } catch {
//                    await MainActor.run {
//                        errorMessage = error.localizedDescription
//                        showError = true
//                        isLoading = false
//                    }
//
//                }
//            }
        } catch {
            print("JSON serialization error: \(error)")
            isLoading = false
        }
    }
    
    
    private func updatePerPersonRent() {
        guard let selectedOption = selectedNumberOfRoommates.first else {
            perPersonRent = 0
            return
        }
        
        let numberOfPeople: Int
        if selectedOption == "6+" {
            numberOfPeople = 6
        } else if selectedOption == "Custom" {
            numberOfPeople = 0
        }
        else if let number = Int(selectedOption) {
            numberOfPeople = number
        } else {
            numberOfPeople = 0
        }
        
        if numberOfPeople > 0 {
            perPersonRent = monthlyBaseRentAmount / numberOfPeople
        } else {
            perPersonRent = 0
        }
    }
    
    
}




#Preview {
    LeasingView()
        .environmentObject(NavigationCoordinator())
        .environmentObject(AppUserManger())
    
    
}
