import SwiftUI

struct OptionButton {
    let label: String
    let backgroundColor: Color
    let pressableColor: Color
    let illustration: String // Name of the SVG file
    let jsonKey: String // Key to use in JSON representation
}

struct JsonKey {
    static let here_to_explore = "here_to_explore"
    static let lease_sublease_property = "lease_property"
    static let find_roomate = "find_roommate"
    static let sell_buy_product = "sell_buy_product"
}

struct OptionButtonConstants {
    static let buttons: [OptionButton] = [
        OptionButton(
            label: "Lease/sublease your property",
            backgroundColor: .white,
            pressableColor: Color(hex: "#FFDAF6"),
            illustration: "lease",
            jsonKey: JsonKey.lease_sublease_property
        ),
        OptionButton(
            label: "Find a room & roommate",
            backgroundColor: .white,
            pressableColor: Color(hex: "#EDD4CE"),
            illustration: "roommate",
            jsonKey: JsonKey.find_roomate
        ),
        OptionButton(
            label: "Sell/buy a product",
            backgroundColor: .white,
            pressableColor: Color(hex: "#CFDFFF"),
            illustration: "selling",
            jsonKey: JsonKey.sell_buy_product
        ),
        OptionButton(
            label: "Here to explore",
            backgroundColor: .white,
            pressableColor: Color(hex: "#EDE2FE"),
            illustration: "explore",
            jsonKey: JsonKey.here_to_explore
        )
    ]
    
    static let roomDecidingButtons: [OptionButton] = [
        OptionButton(
            label: "Got a Roomie,\nNeed a Room?",
            backgroundColor: .white,
            pressableColor: Color(hex: "#CFDFFF"),
            illustration: "sparkles",  // Name for the sparkles SVG illustration
            jsonKey: "need_room"
        ),
        OptionButton(
            label: "Got a Room,\nNeed a Roomie?",
            backgroundColor: .white,
            pressableColor: Color(hex: "#FEDDDE"),
            illustration: "roomie",   // Name for the circular pattern SVG illustration
            jsonKey: "need_roomie"
        )
    ]
    
}
