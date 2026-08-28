//
//  TestFixtures.swift
//  NavigationTests
//

import SwiftUI
@testable import Navigation

struct DummyScreen: View {
    var body: some View { Text("Dummy") }
}

/// A minimal concrete `Route` used to exercise `NavigationRouter`,
/// `AnyRoute`, and `RouteRegistry` without depending on a real feature module.
enum DummyRoute: Route {
    case main
    case detail(id: String)
    case other

    func makeView(router: NavigationRouter) -> some View {
        DummyScreen()
    }
}

/// A second `Route` type with a non-default `sheetDetents`, used to verify
/// `AnyRoute` captures the per-route detent configuration rather than
/// always falling back to the protocol default.
enum CustomDetentRoute: Route {
    case screen

    func makeView(router: NavigationRouter) -> some View {
        DummyScreen()
    }

    var sheetDetents: Set<PresentationDetent> { [.medium] }
}

/// A minimal `NavigationDestination` used to exercise `RouteRegistry` and
/// `DeepLinkRouter` without depending on a real feature's destination type.
enum DummyDestination: NavigationDestination {
    case main
    case detail(id: String)
}

/// A `DeepLinkMapper` that matches on URL host only, for testing
/// `DeepLinkRouter`'s mapper-ordering behavior.
struct StubMapper: DeepLinkMapper {
    let host: String
    let route: AnyRoute

    func map(url: URL) -> AnyRoute? {
        guard url.host == host else { return nil }
        return route
    }
}
