//
//  HousingViewConstants.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/11/24.
//

import Foundation
import SwiftUICore


struct HousingViewConstants{
    
    
    let basePath = "Preferences/Housing"
    
    static let houseOptionButtons : [OptionButton] = [
        OptionButton(
            label: "Condominiums",
            backgroundColor: Color(TextColors.primaryWhite.color),
            pressableColor: Color(hex: "#FFDAF6"),
            illustration:"condo",
            jsonKey: "condo"
        ),
        
        OptionButton(
            label: "Duplexes", backgroundColor: Color(TextColors.primaryWhite.color), pressableColor: Color(hex: "#EDD4CE"), illustration: "duplex",
            jsonKey: "duplexe"
        ),
        
        OptionButton(label: "Apartment", backgroundColor: Color(TextColors.primaryWhite.color), pressableColor: Color(hex: "#CFDFFF"), illustration: "apartment", jsonKey: "apartment"),
        
        
        OptionButton(label: "Studio", backgroundColor: Color(TextColors.primaryWhite.color), pressableColor: Color(hex: "#EDE2FE"), illustration: "studio", jsonKey: "studio")
    ]
}
