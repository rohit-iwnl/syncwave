//
//  OptionButtonConstants.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/9/24.
//


import SwiftUI

struct OptionButton {
    let label: String
    let backgroundColor: Color
    let pressableColor: Color
    let illustration: String // Name of the SVG file
}

struct OptionButtonConstants {
    static let buttons: [OptionButton] = [
        OptionButton(
            label: "Lease/ sublease your property",
            backgroundColor: .white,
            pressableColor: Color(hex: "#FFDAF6"),
            illustration: "lease"
        ),
        OptionButton(
            label: "Find a roommate",
            backgroundColor: .white,
            pressableColor: Color(hex: "#EDD4CE"),
            illustration: "roommate"
        ),
        OptionButton(
            label: "Sell/ buy a product",
            backgroundColor: .white,
            pressableColor: Color(hex: "#CFDFFF"),
            illustration: "selling"
        ),
        OptionButton(
            label: "Here to explore",
            backgroundColor: .white,
            pressableColor: Color(hex: "#EDE2FE"),
            illustration: "explore"
        )
    ]
}
