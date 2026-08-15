//
//  WajhaPaletteTests.swift
//  DesignSystemTests
//

import Testing
import SwiftUI
import UIKit
@testable import DesignSystem

private func components(_ color: Color, style: UIUserInterfaceStyle) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
    let resolved = UIColor(color).resolvedColor(with: UITraitCollection(userInterfaceStyle: style))
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
    resolved.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    return (red, green, blue)
}

private func isClose(_ a: CGFloat, _ b: CGFloat, tolerance: CGFloat = 0.01) -> Bool {
    abs(a - b) < tolerance
}

struct WajhaPaletteTests {

    @Test func fixedBrandColorsAreIdenticalInLightAndDarkMode() {
        let light = components(.wajhaSunset, style: .light)
        let dark = components(.wajhaSunset, style: .dark)
        #expect(isClose(light.red, dark.red))
        #expect(isClose(light.green, dark.green))
        #expect(isClose(light.blue, dark.blue))
        #expect(isClose(light.red, 1.0))
        #expect(isClose(light.green, 0x6A / 255.0))
        #expect(isClose(light.blue, 0x3D / 255.0))
    }

    @Test func backgroundResolvesToSandInLightModeAndInkInDarkMode() {
        let light = components(.wajhaBackground, style: .light)
        #expect(isClose(light.red, 0xF5 / 255.0))
        #expect(isClose(light.green, 0xF4 / 255.0))
        #expect(isClose(light.blue, 0xF2 / 255.0))

        let dark = components(.wajhaBackground, style: .dark)
        #expect(isClose(dark.red, 0x16 / 255.0))
        #expect(isClose(dark.green, 0x13 / 255.0))
        #expect(isClose(dark.blue, 0x29 / 255.0))
    }

    @Test func textPrimaryResolvesToInkInLightModeAndSandInDarkMode() {
        let light = components(.wajhaTextPrimary, style: .light)
        #expect(isClose(light.red, 0x16 / 255.0))
        #expect(isClose(light.green, 0x13 / 255.0))
        #expect(isClose(light.blue, 0x29 / 255.0))

        let dark = components(.wajhaTextPrimary, style: .dark)
        #expect(isClose(dark.red, 0xF5 / 255.0))
        #expect(isClose(dark.green, 0xF4 / 255.0))
        #expect(isClose(dark.blue, 0xF2 / 255.0))
    }

    @Test func surfaceResolvesToWhiteInLightModeAndRaisedInkInDarkMode() {
        let light = components(.wajhaSurface, style: .light)
        #expect(isClose(light.red, 1.0) && isClose(light.green, 1.0) && isClose(light.blue, 1.0))

        let dark = components(.wajhaSurface, style: .dark)
        #expect(isClose(dark.red, 0x21 / 255.0))
        #expect(isClose(dark.green, 0x1D / 255.0))
        #expect(isClose(dark.blue, 0x3D / 255.0))
    }
}
