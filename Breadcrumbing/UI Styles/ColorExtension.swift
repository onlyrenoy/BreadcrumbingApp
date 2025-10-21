//
//  File.swift
//  Breadcrumbing
//
//  Created by Renoy Chowdhury on 21/10/25.
//
import SwiftUI

extension Color {
    static let neuBackground = Color(hex: "f0f0f3")
    static let dropShadow = Color(hex: "aeaec0").opacity(0.3)
    static let dropLight = Color(hex: "ffffff")
}

extension Color {
    init(hex: String) {
        // Remove "#" if present
        let hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hexSanitized.count {
        case 3: // RGB (12-bit, e.g. F0A)
            (a, r, g, b) = (255,
                (int >> 8) * 17,
                (int >> 4 & 0xF) * 17,
                (int & 0xF) * 17)
        case 6: // RGB (24-bit, e.g. FF00AA)
            (a, r, g, b) = (255,
                int >> 16,
                int >> 8 & 0xFF,
                int & 0xFF)
        case 8: // ARGB (32-bit, e.g. FF00AAFF)
            (a, r, g, b) = (
                int >> 24,
                int >> 16 & 0xFF,
                int >> 8 & 0xFF,
                int & 0xFF
            )
        default:
            (a, r, g, b) = (255, 0, 0, 0) // fallback = black
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
