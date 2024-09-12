import SwiftUI

struct HousingPreferencesView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var selectedHouseOptions: [Int: Bool] = [:]
    @State private var isLoading: Bool = false
    @Binding var currentPage: Int
    @Binding var totalPages: Int
    
    @State private var minRent = 400
    @State private var maxRent = 500
    @State private var isRentPickerPresented = false  // To control sheet presentation
    
    var body: some View {
        ZStack {
            // Main HousingPreferencesView content
            GeometryReader { geometry in
                ZStack {
                    TopographyPattern()
                        .fill(TextColors.primaryBlack.color)
                        .opacity(PreferencesScreenConstants.topoPatternOpacity)
                        .ignoresSafeArea(edges: .all)
                    
                    ScrollView {
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
                            
                            VStack {
                                RentRangeDisplayView(minRent: $minRent, maxRent: $maxRent, isRentPickerPresented: $isRentPickerPresented)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                            
                            Spacer(minLength: 50)
                            
                            ContinueButton(
                                isEnabled: checkIfValidSelection(),
                                isLoading: isLoading
                            ) {
                                performAPICallAndNavigate()
                            }
                            .padding(.bottom, 20)
                        }
                        .padding()
                    }
                }
                // Apply blur when isRentPickerPresented is true
                .blur(radius: isRentPickerPresented ? 10 : 0)
                .animation(.easeInOut, value: isRentPickerPresented)  // Smooth transition for blur
            }
            
            // Render RentRangePickerView when presented
            if isRentPickerPresented {
                
                RentRangePickerView(minRent: $minRent, maxRent: $maxRent, isPresented: $isRentPickerPresented)
                    .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .opacity))
                    .animation(.easeInOut(duration: 0.75), value: isRentPickerPresented)
                    .zIndex(1)  // Ensure it appears on top
                    
                
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
        return selectedHouseOptions.values.contains(true)
    }
    
    private func performAPICallAndNavigate() {
        isLoading = true
        
        // Simulated API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let apiCallSucceeded = true
            isLoading = false
            
            if apiCallSucceeded {
                withAnimation {
                    currentPage = min(currentPage + 1, totalPages - 1)
                }
            }
        }
    }
}

struct RentRangeDisplayView: View {
    @Binding var minRent: Int
    @Binding var maxRent: Int
    @Binding var isRentPickerPresented: Bool
    
    var body: some View {
        Button(action: {
            isRentPickerPresented = true
        }) {
            HStack {
                Text("Monthly base rent?")
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
                Text("$\(minRent) - $\(maxRent)")
                    .font(.headline)
                    .foregroundColor(.black)
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }
}



#Preview {
    HousingPreferencesView(currentPage: .constant(3), totalPages: .constant(3))
    
    
}
