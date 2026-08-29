//
//  PresentedNavigationHost.swift
//  ModularizedByFeature
//
//  Created by ali alhawas on 31/03/2026.
//

import SwiftUI

/// Hosts a newly presented navigation flow with its own internal router.
///
/// Use this for:
/// - sheet flows
/// - full-screen flows
/// - nested modal navigation
///
/// The host injects its internal `router` into the environment of the
/// presented route and of every pushed destination, so a `Route`'s `makeView`
/// does not need to add `.environmentObject(router)` itself.
public struct PresentedNavigationHost: View {
    @StateObject private var router = NavigationRouter()
    private let route: AnyRoute

    public init(route: AnyRoute) {
        self.route = route
    }

    public var body: some View {
        NavigationStack(path: $router.routes) {
            route
                .makeView(router: router)
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
