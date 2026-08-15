//
//  Color+Hex.swift
//  SharedLibraries
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension Color {
    /// Fixed color from a 0xRRGGBB literal — same value in light and dark mode.
    init(hex: UInt32) {
        let red = Double((hex >> 16) & 0xFF) / 255
        let green = Double((hex >> 8) & 0xFF) / 255
        let blue = Double(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue)
    }

    /// Adaptive color — resolves to `light` or `dark` based on the current
    /// interface style, without needing an asset catalog entry.
    init(light: UInt32, dark: UInt32) {
        #if canImport(UIKit)
        self.init(UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
        })
        #else
        self.init(hex: light)
        #endif
    }
}

#if canImport(UIKit)
private extension UIColor {
    convenience init(hex: UInt32) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255
        let green = CGFloat((hex >> 8) & 0xFF) / 255
        let blue = CGFloat(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
#endif
