//
//  ExploreIllustration.swift
//  Stealth
//
//  Created by Rohit Manivel on 9/10/24.
//

import SwiftUI

struct ExploreIllustration: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.55227*width, y: 0.6425*height))
        path.addLine(to: CGPoint(x: 0.63718*width, y: 0.55759*height))
        path.addLine(to: CGPoint(x: 0.72209*width, y: 0.6425*height))
        path.addLine(to: CGPoint(x: 0.63718*width, y: 0.72741*height))
        path.addLine(to: CGPoint(x: 0.55227*width, y: 0.6425*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.0119*width, y: 0.60627*height))
        path.addLine(to: CGPoint(x: 0.60627*width, y: 0.0119*height))
        path.addLine(to: CGPoint(x: 1.20064*width, y: 0.60627*height))
        path.addLine(to: CGPoint(x: 0.60627*width, y: 1.20064*height))
        path.addLine(to: CGPoint(x: 0.0119*width, y: 0.60627*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.10197*width, y: 0.61232*height))
        path.addLine(to: CGPoint(x: 0.61142*width, y: 0.10286*height))
        path.addLine(to: CGPoint(x: 1.12088*width, y: 0.61232*height))
        path.addLine(to: CGPoint(x: 0.61142*width, y: 1.12177*height))
        path.addLine(to: CGPoint(x: 0.10197*width, y: 0.61232*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.19203*width, y: 0.61835*height))
        path.addLine(to: CGPoint(x: 0.61657*width, y: 0.1938*height))
        path.addLine(to: CGPoint(x: 1.04112*width, y: 0.61835*height))
        path.addLine(to: CGPoint(x: 0.61657*width, y: 1.0429*height))
        path.addLine(to: CGPoint(x: 0.19203*width, y: 0.61835*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.28208*width, y: 0.6244*height))
        path.addLine(to: CGPoint(x: 0.62172*width, y: 0.28476*height))
        path.addLine(to: CGPoint(x: 0.96135*width, y: 0.6244*height))
        path.addLine(to: CGPoint(x: 0.62172*width, y: 0.96403*height))
        path.addLine(to: CGPoint(x: 0.28208*width, y: 0.6244*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.37214*width, y: 0.63041*height))
        path.addLine(to: CGPoint(x: 0.62687*width, y: 0.37568*height))
        path.addLine(to: CGPoint(x: 0.8816*width, y: 0.63041*height))
        path.addLine(to: CGPoint(x: 0.62687*width, y: 0.88514*height))
        path.addLine(to: CGPoint(x: 0.37214*width, y: 0.63041*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.46221*width, y: 0.63645*height))
        path.addLine(to: CGPoint(x: 0.63203*width, y: 0.46663*height))
        path.addLine(to: CGPoint(x: 0.80185*width, y: 0.63645*height))
        path.addLine(to: CGPoint(x: 0.63203*width, y: 0.80627*height))
        path.addLine(to: CGPoint(x: 0.46221*width, y: 0.63645*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.55227*width, y: 0.6425*height))
        path.addLine(to: CGPoint(x: 0.63718*width, y: 0.55759*height))
        path.addLine(to: CGPoint(x: 0.72209*width, y: 0.6425*height))
        path.addLine(to: CGPoint(x: 0.63718*width, y: 0.72741*height))
        path.addLine(to: CGPoint(x: 0.55227*width, y: 0.6425*height))
        path.closeSubpath()
        return path
    }
}
