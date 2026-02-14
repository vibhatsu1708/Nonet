//
//  Color+Palette.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

extension Color {
    // User Provided Palette
    // 8c1c13, bf4342, e7d7c1, a78a7f, 735751
    
    static let nonetDarkRed = Color(hex: "f4f1de")
    static let nonetErrorCellBgColor = Color(hex: "bf4342")
    static let nonetErrorCellTextColor = Color(hex: "8c1c13")
    static let nonetPrimaryTextColor = Color(hex: "231f20")
    static let nonetHeartFillColor = Color(hex: "c52233")
    static let nonetSeparatorColor = Color(hex: "432818")
    static let nonetRed = Color(hex: "bf4342")
    static let nonetBeige = Color(hex: "220901")
    static let nonetTaupe = Color(hex: "a78a7f")
    static let nonetDarkBrown = Color(hex: "432818")
    
    // Semantic aliases
    static let nonetBackground = nonetDarkRed
    static let nonetPrimaryText = nonetBeige
    static let nonetSecondaryText = nonetTaupe
    static let nonetAccent = nonetRed
    static let nonetContainer = nonetDarkBrown.opacity(0.2)
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
