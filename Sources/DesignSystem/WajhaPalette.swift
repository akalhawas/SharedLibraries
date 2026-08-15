//
//  WajhaPalette.swift
//  SharedLibraries
//

import SwiftUI

/// Wajha's brand palette. Fixed brand colors are the same in light and dark
/// mode (they *are* the brand); semantic tokens adapt automatically — use
/// the semantic tokens for backgrounds/surfaces/text, and the fixed colors
/// when a specific brand hue is required regardless of theme (e.g. a
/// category tag, a chart series).
///
/// See `docs/wajha-identity.html` in the Wajha app repo for the full
/// palette reference (swatches, tokens, in-context preview, usage notes).
public extension Color {

    // MARK: - Brand (fixed)

    /// #161329 — near-black with a violet undertone. The identity's hero color.
    static let wajhaInk = Color(hex: 0x161329)

    /// #FF6A3D — the one bold accent. Primary buttons, key CTAs.
    static let wajhaSunset = Color(hex: 0xFF6A3D)

    /// #C24A28 — muted variant of Sunset. Use for text/icons on light
    /// backgrounds where full Sunset wouldn't hit contrast, and pressed states.
    static let wajhaSunsetDim = Color(hex: 0xC24A28)

    /// #F5F4F2 — warm-neutral off-white. Light mode's ground.
    static let wajhaSand = Color(hex: 0xF5F4F2)

    /// #22A385 — restrained secondary accent. Use sparingly (secondary tags,
    /// success states) — never as a second primary color.
    static let wajhaPalm = Color(hex: 0x22A385)

    // MARK: - Semantic (adaptive: light / dark)

    /// Screen background. Sand in light mode, Ink in dark mode.
    static let wajhaBackground = Color(light: 0xF5F4F2, dark: 0x161329)

    /// Card/sheet surface, raised above the background. White in light
    /// mode, a lifted dark violet in dark mode.
    static let wajhaSurface = Color(light: 0xFFFFFF, dark: 0x211D3D)

    /// Primary text/icon color. Ink in light mode, Sand in dark mode.
    static let wajhaTextPrimary = Color(light: 0x161329, dark: 0xF5F4F2)

    /// Secondary text/icon color (captions, metadata, timestamps).
    static let wajhaTextSecondary = Color(light: 0x5C5468, dark: 0xA79FC2)
}
