//
//  PersonalTraitView.swift
//  Stealth
//
//  Created by Rohit Manivel on 3/2/25.
//

import SwiftUI

struct PersonalTraitView: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigationCoordinator : NavigationCoordinator
    
    @Binding var currentPage: Int
    @Binding var totalPages: Int
    
    @State private var showSkipAlert : Bool = false
    
    
    @State private var showIncompleteFieldsAlert = false
    @State private var incompleteFields: [String] = []
    
    
    
    var body: some View {
        
        VStack{
            VStack{
                PreferencesToolbar(currentPage: $navigationCoordinator.currentPage, totalPages: $navigationCoordinator.totalPages, showPages: .constant(true), onBackTap: handleBackTap ) {
                    showSkipAlert = true
                }
                ScrollView{
                    
                    //MARK : - Header
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 4){
                            HStack {Text("Lets get to know you better")
                                    .font(.sora(.largeTitle, weight: .semibold))
                                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                    .lineLimit(3)
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text("This helps us find the best matches for you")
                                    .font(.sora(.callout, weight: .regular))
                                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                    .lineLimit(2)
                                    .foregroundStyle(.gray)
                                
                                Spacer()
                            }
                        }
                    }
                    
                    
                    // MARK : - Non scored questions
                    VStack(alignment: .leading, spacing: 10) {
                        
                    }
                    
                    
                    
                }
                .padding(.horizontal)
            }
            
        }.alert(isPresented: $showSkipAlert) {
            Alert(title: Text("Skip personal traits preferences"), message: Text("Are you sure?. This may lead to fewer hyperpersonalized matches. Don't worry you can complete it later in settings"), primaryButton: .default(Text("Proceed")){
                handleSkip()
            }, secondaryButton: .cancel())
        }
        
    }
    
    private func handleBackTap(){
        withAnimation {
            if !navigationCoordinator.path.isEmpty {
                navigationCoordinator.path.removeLast()
                navigationCoordinator.currentPage -= 1
            } else {
                dismiss()
            }
        }
    }
    
    private func handleSkip(){
    }
    
}

#Preview {
    PersonalTraitView(currentPage: .constant(1), totalPages: .constant(3))
        .environmentObject(NavigationCoordinator())
}
