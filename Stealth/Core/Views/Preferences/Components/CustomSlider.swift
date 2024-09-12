//
//  CustomSlider.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/12/24.
//

import SwiftUI
import Sliders


struct RentRangeSlider: View {
    @State var range = 0.2...0.8
    
    var body: some View {
        RangeSlider(range: $range)
            .rangeSliderStyle(
                HorizontalRangeSliderStyle(
                    track: HorizontalRangeTrack(
                        view: Capsule().foregroundColor(.black)
                    )
                    .background(Capsule().foregroundColor(.gray))
                    .frame(height: 6),
                    lowerThumb: RoundedRectangle(cornerRadius: 2).foregroundStyle(.white),
                    
                    upperThumb:  RoundedRectangle(cornerRadius: 2).foregroundStyle(.white),
                    lowerThumbSize: CGSize(width: 20, height: 20),
                    upperThumbSize: CGSize(width: 20, height: 20)
                )
            )
            .padding()
    }
}



#Preview {
    VStack{
        Spacer()
        RentRangeSlider()
        Spacer()
    }
    .background(.gray.opacity(0.5))
    
}
