//
//  Category.swift
//  Plan with Charity
//
//  Created by Ilya Derezovskiy on 18.05.2023.
//

import SwiftUI

enum Category: String, CaseIterable {
    case general = "General"
    case bug = "Bug"
    case idea = "Idea"
    case modifiers = "Modifiers"
    case challenge = "Challenge"
    case coding = "Coding"
    
    var color: Color {
        switch self {
        case .general:
            return Color("Crayola Bleuet")
        case .bug:
            return Color("Periwinkle")
        case .idea:
            return Color("Celadon")
        case .modifiers:
            return Color("Pastel turquoise")
        case .challenge:
            return Color("Chewing gum")
        case .coding:
            return Color("Pastel Purple")
        }
    }
}

