import SwiftUI

struct HousingPreferencesView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var selectedHouseOptions: [Int: Bool] = [:]
    @State private var isLoading: Bool = false
    @Binding var currentPage: Int
    @Binding var totalPages: Int
    
    @State private var minRent : Double = 400
    @State private var maxRent : Double = 650
    
    @State private var rentRange : RentRangeSlider  = RentRangeSlider(min: 400, max: 550)
    
    @State private var propertySizeRange : propertySizeSlider = propertySizeSlider(min: 800, max: 1100)
    @State private var selectedBedrooms : Set<String> = []
    @State private var selectedBathrooms : Set<String> = []
    @State private var selectedNumberOfRoommates : Set<String> = []
    
    @State private var selectedFurnishing : Set<String> = []
    
    @State private var selectedAmenities : Set<String> = []
    
    @Binding var isShowingHousingPreferences : Bool
    @EnvironmentObject var appUserStateManager: AppUserManger
    
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showSkipAlert = false
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    @State private var showIncompleteFieldsAlert = false
    @State private var incompleteFields: [String] = []
    
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
                                    Text("Share what you're looking for in a property?")
                                        .font(.sora(.largeTitle, weight: .semibold))
                                        .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                        .lineLimit(3)
                                    Text("Type of Property you're looking for? (Select all that apply)")
                                        .font(.sora(.callout, weight: .regular))
                                        .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                        .lineLimit(2)
                                        .foregroundStyle(.gray)
                                }
                                
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
                                
                                VStack(spacing: 5) {
                                    
                                    HStack {
                                        Text("Desired rental range per person")
                                            .font(.sora(.body))
                                            .lineLimit(1)
                                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text("$\(Int(rentRange.min)) - $\(Int(rentRange.max))")
                                            .font(.sora(.body, weight: .medium))
                                            .fontDesign(.rounded)
                                            .lineLimit(1)
                                            .minimumScaleFactor(2)
                                        
                                        Spacer()
                                    }
                                    
                                    
                                    CustomSlider(defaultMinValue: $rentRange.min, defaultMaxValue: $rentRange.max, minValue: 200, maxValue: 4000, steps: 50)
                                }
                                
                                VStack(spacing: 5){
                                    
                                    HStack{
                                        Text("Property size")
                                            .font(.sora(.body))
                                            .lineLimit(1)
                                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                        Spacer()
                                    }
                                    
                                    HStack{
                                        Text("\(Int(propertySizeRange.min)) Sqft - \(Int(propertySizeRange.max)) Sqft")
                                            .font(.sora(.body, weight: .medium))
                                            .fontDesign(.rounded)
                                            .lineLimit(1)
                                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                        Spacer()
                                    }
                                    
                                    CustomSlider(defaultMinValue: $propertySizeRange.min, defaultMaxValue: $propertySizeRange.max, minValue: 500, maxValue: 3000, steps: 50)
                                    
                                }
                                
                                
                                VStack(spacing : 5){
                                    HStack {
                                        Text("Bedrooms")
                                            .font(.sora(.body))
                                            .lineLimit(1)
                                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                        
                                        Spacer()
                                    }
                                    CustomSelector(selectedOptions: $selectedBedrooms, options: BedroomsOptions.options, isScrollable: true, lineLimit: 1)
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
                                    CustomSelector(selectedOptions: $selectedBathrooms, options: BathroomOptions.options, isScrollable: true, lineLimit: 1)
                                        .padding(.vertical)
                                }
                                
                                VStack(spacing : 5){
                                    HStack {
                                        Text("Preferred number of people per unit")
                                            .font(.sora(.body))
                                            .lineLimit(1)
                                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                        
                                        Spacer()
                                    }
                                    CustomSelector(selectedOptions: $selectedNumberOfRoommates, options: RoomateOptions.options, isScrollable: true, lineLimit: 1)
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
                                    CustomSelector(selectedOptions: $selectedFurnishing, options: FurnishingOptions.options, isScrollable: true, lineLimit: 1)
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
                                
                                ContinueButton(
                                    isEnabled: true,
                                    isLoading: isLoading
                                ) {
                                    if checkIfValidSelection() {
                                        Task {
                                            await performAPICallAndNavigate()
                                        }
                                    } else {
                                        incompleteFields = getIncompleteFields()
                                        showIncompleteFieldsAlert = true
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
        .alert(isPresented: $showSkipAlert) {
            Alert(
                title: Text("Skip Property preferences?"),
                message: Text("Skipping property preferences? You'll get fewer spot-on recs. No stress though, you can update them later when finishing your profile!"),
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
        .alert("Incomplete Fields", isPresented: $showIncompleteFieldsAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please fill in the following fields:\n" + incompleteFields.joined(separator: "\n"))
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
    
    func convertToHousingPreferencesJSON(supabase_id : String) -> [String: Any] {
        // Convert selected house options to property types
        let propertyTypes: [String] = selectedHouseOptions.compactMap { index, isSelected in
            guard isSelected else { return nil }
            switch index {
            case 0: return "condo"
            case 1: return "duplex"
            case 2: return "apartment"
            case 3: return "studio"
            default: return nil
            }
        }
        
        let bedrooms = Array(selectedBedrooms).map { bedroom -> String in
            // Remove "BR" and any whitespace, keeping only the number
            return bedroom.replacingOccurrences(of: "BR", with: "")
                .replacingOccurrences(of: " ", with: "")
        }
        
        
        // Create the nested housing preferences object
        let housingPreferences: [String: Any] = [
            "property_types": propertyTypes,
            "rent_range": [
                "min": Int(rentRange.min),
                "max": Int(rentRange.max)
            ],
            "property_size": [
                "min": Int(propertySizeRange.min),
                "max": Int(propertySizeRange.max)
            ],
            "bedrooms": bedrooms.map { $0.lowercased() },
            "bathrooms": Array(selectedBathrooms).map { $0.lowercased() },
            "preferred_roommates": Array(selectedNumberOfRoommates).map { $0.lowercased() },
            "furnishing": Array(selectedFurnishing).map { $0.lowercased() },
            "amenities": Array(selectedAmenities)
        ]
        
        // Create the final JSON structure
        let json: [String: Any] = [
            "supabase_id": supabase_id.lowercased(),
            "housing_preferences": housingPreferences
        ]
        
        return json
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
        selectedHouseOptions[buttonIndex, default: false].toggle()
    }
    
    private func checkIfValidSelection() -> Bool {
        return selectedHouseOptions.values.contains(true) &&
        !selectedBedrooms.isEmpty &&
        !selectedBathrooms.isEmpty &&
        !selectedNumberOfRoommates.isEmpty &&
        !selectedFurnishing.isEmpty &&
        !selectedAmenities.isEmpty
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
        let jsonBody = convertToHousingPreferencesJSON(supabase_id: userId)
        
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
        
        
        guard let url = URL(string: "http://159.89.222.41:8000/api/onboarding/set-housing-preferences") else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer Naandhaandaungoppan", forHTTPHeaderField: "Authorization")
        
        // Add try keyword here since JSONSerialization.data can throw
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
            
            // Make API call
            Task {
                do {
                    let (_data, response) = try await URLSession.shared.data(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw URLError(.badServerResponse)
                    }
                    
                    // Check status code
                    guard 200...299 ~= httpResponse.statusCode else {
                        throw URLError(.badServerResponse)
                    }
                    
                    // Try to decode response if needed
                    // let decodedResponse = try JSONDecoder().decode(YourResponseType.self, from: data)
                    
                    await MainActor.run {
                        isLoading = false
                        self.navigationCoordinator.resetToHome()
                    }
                    
                } catch {
                    await MainActor.run {
                        errorMessage = error.localizedDescription
                        showError = true
                        isLoading = false
                    }
                    
                }
            }
        } catch {
            print("JSON serialization error: \(error)")
            isLoading = false
        }
    }
    
    private func getIncompleteFields() -> [String] {
        var incomplete: [String] = []
        
        if !selectedHouseOptions.values.contains(true) {
            incomplete.append("• Property Type")
        }
        if selectedBedrooms.isEmpty {
            incomplete.append("• Bedrooms")
        }
        if selectedBathrooms.isEmpty {
            incomplete.append("• Bathrooms")
        }
        if selectedNumberOfRoommates.isEmpty {
            incomplete.append("• Number of People per Unit")
        }
        if selectedFurnishing.isEmpty {
            incomplete.append("• Furnishing")
        }
        if selectedAmenities.isEmpty {
            incomplete.append("• Amenities")
        }
        
        return incomplete
    }
    
}

#Preview {
    HousingPreferencesView(currentPage: .constant(3), totalPages: .constant(3), isShowingHousingPreferences: .constant(true))
        .environmentObject(NavigationCoordinator())
        .environmentObject(AppUserManger())
    
    
}
