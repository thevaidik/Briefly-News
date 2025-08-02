//
//  ColorExtensions.swift
//  Briefly
//
//  Created by Vaidik Dubey
//

import SwiftUI

// Extension to support light/dark mode colors
extension Color {
    static func adaptive(light: Color, dark: Color) -> Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
}