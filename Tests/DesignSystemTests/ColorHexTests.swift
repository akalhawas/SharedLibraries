//
//  ColorHexTests.swift
//  DesignSystemTests
//

import Testing
import SwiftUI
import UIKit
@testable import DesignSystem

private func components(_ color: Color) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
    UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    return (red, green, blue)
}

private func isClose(_ a: CGFloat, _ b: CGFloat, tolerance: CGFloat = 0.005) -> Bool {
    abs(a - b) < tolerance
}

struct ColorHexTests {

    @Test func decodesEachChannelFromA0xRRGGBBLiteral() {
        let (red, green, blue) = components(Color(hex: 0xFF6A3D))
        #expect(isClose(red, 1.0))
        #expect(isClose(green, 0x6A / 255.0))
        #expect(isClose(blue, 0x3D / 255.0))
    }

    @Test func decodesBlackAndWhiteCorrectly() {
        let black = components(Color(hex: 0x000000))
        #expect(isClose(black.red, 0) && isClose(black.green, 0) && isClose(black.blue, 0))

        let white = components(Color(hex: 0xFFFFFF))
        #expect(isClose(white.red, 1) && isClose(white.green, 1) && isClose(white.blue, 1))
    }

    @Test func adaptiveColorResolvesToTheLightValueInLightMode() {
        let color = Color(light: 0xF5F4F2, dark: 0x161329)
        let resolved = UIColor(color).resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        resolved.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        #expect(isClose(red, 0xF5 / 255.0))
        #expect(isClose(green, 0xF4 / 255.0))
        #expect(isClose(blue, 0xF2 / 255.0))
    }

    @Test func adaptiveColorResolvesToTheDarkValueInDarkMode() {
        let color = Color(light: 0xF5F4F2, dark: 0x161329)
        let resolved = UIColor(color).resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        resolved.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        #expect(isClose(red, 0x16 / 255.0))
        #expect(isClose(green, 0x13 / 255.0))
        #expect(isClose(blue, 0x29 / 255.0))
    }
}
