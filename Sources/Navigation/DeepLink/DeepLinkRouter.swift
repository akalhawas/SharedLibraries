//
//  DeepLinkRouter.swift
//  Navigation
//
//  Created by ali alhawas on 30/05/2026.
//

import SwiftUI

/// Resolves incoming URLs into routes using the registered ``DeepLinkMapper``
/// implementations.
@MainActor
public final class DeepLinkRouter {

    /// Shared router instance. Features register their own ``DeepLinkMapper``
    /// here (typically from their module's `register()`) instead of the app
    /// target hand-assembling the full mapper list.
    public static let shared = DeepLinkRouter(mappers: [])

    private var mappers: [DeepLinkMapper]

    public init(mappers: [DeepLinkMapper]) {
        self.mappers = mappers
    }

    /// Registers an additional mapper, evaluated after any already registered.
    public func register(_ mapper: DeepLinkMapper) {
        mappers.append(mapper)
    }

    /// Resolves a URL into a route.
    ///
    /// The registered mappers are evaluated in order until one returns a
    /// matching route.
    ///
    /// - Parameter url: The incoming deep link URL.
    /// - Returns: The resolved ``AnyRoute`` if one exists; otherwise, `nil`.
    public func resolve(url: URL) -> AnyRoute? {
        for mapper in mappers {
            if let route = mapper.map(url: url) {
                return route
            }
        }
        assertionFailure("No mapper resolved url: \(url)")
        return nil
    }
}
