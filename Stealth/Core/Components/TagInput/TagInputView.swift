import AlertToast
import SwiftUI

struct TagInputView: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    let headerText: String  // Customizable header text
    let placeholderText: String  // Customizable placeholder text

    @Binding var tags: [String]  // List of tags
    @State private var inputText: String = ""  // Input text for new tags
    @State private var showToast: Bool = false  // Controls the toast visibility
    @State private var toastMessage: String = ""  // Message to display in the toast
    
    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            Text(headerText)
                .font(.sora(.headline, weight: .medium))
                .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                .foregroundColor(.black)

            // Input Field with Add Icon Inside
            HStack {
                TextField(placeholderText, text: $inputText)
                    .padding(.vertical, 12)
                    .padding(.leading, 12)
                    .font(.sora(.subheadline, weight: .regular))
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    .onChange(of: inputText) { _ in
                        handleCommaSeparatedInput()
                    }
                    .onSubmit {
                        addTag()
                    }
                    .keyboardType(.default)
                    .addDismissButton(text: "Done")

                Divider()
                    .frame(height: 20)
                    .background(Color.black.opacity(0.5))

                Button(action: { Task { @MainActor in addTag() } }) {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .padding(.trailing, 12)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.5), lineWidth: 1)
                    .background(Color.gray.opacity(0.1).cornerRadius(8))
            )

            // Tags Display using FlowLayout
            FlowLayout(horizontalSpacing: 10, verticalSpacing: 15) {
                ForEach(tags, id: \.self) { tag in
                    TagView(tag: tag) {
                        removeTag(tag)
                    }
                    .transition(.scale.combined(with: .opacity))  // Animate insert/removal
                }
            }
        }

        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: tags)  // Smooth animation for changes
        // Toast for feedback messages
        .toast(isPresenting: $showToast) {
            AlertToast(type: .error(Color.red), title: toastMessage)
        }
        .overlay(alignment: .bottomTrailing) {
                    if isInputFocused {
                        Button(action: {
                            isInputFocused = false
                        }) {
                            Image(systemName: "keyboard.chevron.compact.down")
                                .foregroundColor(.gray)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                        .padding([.bottom, .trailing], 16)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut, value: isInputFocused)
                    }
                }
    }

    private func handleCommaSeparatedInput() {
        let components = inputText.split(separator: ",").map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        if components.count > 1 {
            for component in components.dropLast() {
                inputText = components.last ?? ""
                if isValidTag(component) {
                    addTag(component.capitalizedFirst())
                } else {
                    showErrorToast("Invalid or duplicate tag!")
                }
            }
        }
    }

    private func addTag(_ tagToAdd: String? = nil) {
        let tag =
            (tagToAdd
            ?? inputText.trimmingCharacters(in: .whitespacesAndNewlines))
            .capitalizedFirst()

        guard !tag.isEmpty else { return }

        if isValidTag(tag) {
            tags.append(tag)
            inputText = ""
        } else {
            showErrorToast("Invalid or duplicate tag!")
        }
    }

    private func removeTag(_ tag: String) {
        print("Before removal: \(tags)")
        tags.removeAll { $0 == tag }
        print("After removal: \(tags)")
    }


    private func isValidTag(_ tag: String) -> Bool {
        let allowedCharacters = CharacterSet.alphanumerics.union(
            CharacterSet.whitespaces)
        return !tags.contains(tag)
            && tag.rangeOfCharacter(from: allowedCharacters.inverted) == nil
    }

    private func showErrorToast(_ message: String) {
        toastMessage = message
        showToast = true
    }
}

#Preview {

    @Previewable @State var tags: [String] = []

    TagInputView(
        headerText: "Languages you prefer",
        placeholderText: "Select your preferred languages",
        tags: $tags
    )
}
