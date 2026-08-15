//
//  WajhaPalette.swift
//  SharedLibraries
//

import SwiftUI

/// Wajha's brand palette. Backed by `Assets.xcassets` color sets — each
/// fixed brand color has a single "Any" value used in both appearances,
/// each semantic token has a paired "Any"/"Dark" value baked in, so light
/// and dark mode resolve automatically with no runtime branching.
///
/// See `docs/wajha-identity.html` in the Wajha app repo for the full
/// palette reference (swatches, tokens, in-context preview, usage notes).
public extension Color {

    // MARK: - Brand (fixed)

    /// #161329 — near-black with a violet undertone. The identity's hero color.
    static let wajhaInk = Color("WajhaInk", bundle: .module)

    /// #FF6A3D — the one bold accent. Primary buttons, key CTAs.
    static let wajhaSunset = Color("WajhaSunset", bundle: .module)

    /// #C24A28 — muted variant of Sunset. Use for text/icons on light
    /// backgrounds where full Sunset wouldn't hit contrast, and pressed states.
    static let wajhaSunsetDim = Color("WajhaSunsetDim", bundle: .module)

    /// #F5F4F2 — warm-neutral off-white. Light mode's ground.
    static let wajhaSand = Color("WajhaSand", bundle: .module)

    /// #22A385 — restrained secondary accent. Use sparingly (secondary tags,
    /// success states) — never as a second primary color.
    static let wajhaPalm = Color("WajhaPalm", bundle: .module)

    // MARK: - Semantic (adaptive: light / dark)

    /// Screen background. Sand in light mode, Ink in dark mode.
    static let wajhaBackground = Color("WajhaBackground", bundle: .module)

    /// Card/sheet surface, raised above the background. White in light
    /// mode, a lifted dark violet in dark mode.
    static let wajhaSurface = Color("WajhaSurface", bundle: .module)

    /// Primary text/icon color. Ink in light mode, Sand in dark mode.
    static let wajhaTextPrimary = Color("WajhaTextPrimary", bundle: .module)

    /// Secondary text/icon color (captions, metadata, timestamps).
    static let wajhaTextSecondary = Color("WajhaTextSecondary", bundle: .module)
}
