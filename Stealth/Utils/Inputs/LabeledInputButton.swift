//
//  LabeledInputButton.swift
//  Stealth
//
//  Created by Rohit Manivel on 11/2/24.
//

import SwiftUI

enum Field: Hashable {
    case baseRent
    case perPersonRent
    case squareFootage
    case generateDescription
}

struct LabeledInputButton: View {
    let label: String
    let placeholder: String
    @Binding var value: Int
    let keyboardType: UIKeyboardType
    @State private var textInput: String = ""
    @State private var showError = false
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var leftSideText: String = ""
    
    // Change this to FocusState binding
    @FocusState.Binding var focusedField: Field?
    let field: Field
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .font(.sora(.headline, weight: .regular))
                .foregroundColor(.black)
                .padding(.vertical,4)
                .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
            
            HStack(spacing: 0) {
                Text(leftSideText)
                    .foregroundColor(.black)
                    .padding(.leading)
                
                Divider()
                    .frame(height: 20)
                    .padding(.horizontal, 8)
                
                TextField(placeholder, text: Binding(
                    get: { value == 0 ? "" : "\(value)" },
                    set: { newValue in
                        if !newValue.isEmpty {
                            if let number = Int(newValue) {
                                value = number
                                showError = false
                            } else {
                                showError = true
                                value = Int(newValue.filter { $0.isNumber }) ?? 0
                            }
                        } else {
                            value = 0
                        }
                    }
                ))
                .font(.sora(.body, weight: .regular))
                .keyboardType(keyboardType)
                .focused($focusedField, equals: field)
            }
            .padding(.vertical)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(showError ? Color.red : Color.gray.opacity(0.3))
            )
            
            if showError {
                Text("Please enter numbers only")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
}






// Preview
struct LabeledInputButtonPreview: View {
    @State private var rentValue: Int = 0
    @FocusState private var focusedField: Field?
    
    var body: some View {
        LabeledInputButton(
            label: "Monthly base rent of the unit?",
            placeholder: "Enter your unit base rent",
            value: $rentValue,
            keyboardType: .numberPad,
            leftSideText: "$",
            focusedField: $focusedField,
            field: .baseRent
        )
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
            }
        }
    }
}


#Preview {
    LabeledInputButtonPreview()
}
