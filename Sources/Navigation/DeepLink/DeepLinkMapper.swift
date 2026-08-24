//
//  DeepLinkMapper.swift
//  ModularizedByFeature
//
//  Created by ali alhawas on 30/05/2026.
//

import SwiftUI

/// Maps an incoming URL directly to a route.
public protocol DeepLinkMapper {
    /// Attempts to map the given URL to a route.
    ///
    /// - Parameter url: The incoming deep link URL.
    /// - Returns: An ``AnyRoute`` if the URL is supported; otherwise, `nil`.
    func map(url: URL) -> AnyRoute?
}
