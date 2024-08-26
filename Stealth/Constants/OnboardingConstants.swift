//
//  OnboardingConstants.swift
//  Stealth
//
//  Created by Rohit Manivel on 8/25/24.
//
import Foundation
import SwiftUI

struct OnboardingPage {
    let color : Color
    let image : String
    let title : String
    let description: String
}

struct OnboardingConstants{
    static let pages : [OnboardingPage] = [
        OnboardingPage(
            color: Color(hex: "#CDE3F3"),
            image: "circles",
            title: "Welcome to Stealth",
            description: "Your all-in-one solution for student life, Find accommodation, Organize schedules, simplify tasks and many more."
        ),
        OnboardingPage(
            color: Color(hex: "#F8EED5"),
            image: "star",
            title: "Find your Perfect Place",
            description: "Discover tailored accommodations within budget. From cozy studios to shared spaces along with your preferred roommate."
        ),
        OnboardingPage(
            color: Color(hex: "#D4ECCD"),
            image: "aistar",
            title: "Simplify your life",
            description: "Manage schedules, set reminders, access resources. Let’s make your journey easier."
        )
    ]
    
    static let TopoPatternOpacity : Double = 0.4
    
    static let illustrationCornerRadius : CGFloat = 20
    static let buttonCornerRadius : CGFloat = 16
    
    // First Login Check
}
