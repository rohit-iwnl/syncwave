import SwiftUI

struct OptionButton {
    let label: String
    let backgroundColor: Color
    let pressableColor: Color
    let illustration: String // Name of the SVG file
    let jsonKey: String // Key to use in JSON representation
}

struct OptionButtonConstants {
    static let buttons: [OptionButton] = [
        OptionButton(
            label: "Lease/sublease your property",
            backgroundColor: .white,
            pressableColor: Color(hex: "#FFDAF6"),
            illustration: "lease",
            jsonKey: "lease_property"
        ),
        OptionButton(
            label: "Find a room & roommate",
            backgroundColor: .white,
            pressableColor: Color(hex: "#EDD4CE"),
            illustration: "roommate",
            jsonKey: "find_roommate"
        ),
        OptionButton(
            label: "Sell/buy a product",
            backgroundColor: .white,
            pressableColor: Color(hex: "#CFDFFF"),
            illustration: "selling",
            jsonKey: "sell_buy_product"
        ),
        OptionButton(
            label: "Here to explore",
            backgroundColor: .white,
            pressableColor: Color(hex: "#EDE2FE"),
            illustration: "explore",
            jsonKey: "here_to_explore"
        )
    ]
}
