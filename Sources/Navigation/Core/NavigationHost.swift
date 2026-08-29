//
//  NavigationHost.swift
//  ModularizedByFeature
//
//  Created by ali alhawas on 31/03/2026.
//

import SwiftUI

/// Hosts an existing navigation flow whose router is owned externally.
///
/// Use this for:
/// - app roots
/// - tab roots
/// - feature entry points
///
/// The host injects `router` into the environment of the root view and of
/// every pushed destination, so a `Route`'s `makeView` does not need to add
/// `.environmentObject(router)` itself.
@MainActor
public struct NavigationHost<Root: View>: View {
    @ObservedObject private var router: NavigationRouter
    private let root: Root

    public init(
        router: NavigationRouter,
        @ViewBuilder root: () -> Root
    ) {
        self.router = router
        self.root = root()
    }

    public var body: some View {
        NavigationStack(path: $router.routes) {
            root
                .environmentObject(router)
                .navigationDestination(for: AnyRoute.self) { route in
                    route.makeView(router: router)
                        .environmentObject(router)
                }
                .sheet(item: $router.sheetItem) { item in
                    PresentedNavigationHost(route: item.route)
                        .presentationDetents(item.configuration.detents)
                        .presentationDragIndicator(.visible)
                }
#if os(iOS)
                .fullScreenCover(item: $router.fullScreenRoute) { route in
                    PresentedNavigationHost(route: route)
                }
#endif
        }
    }
}
