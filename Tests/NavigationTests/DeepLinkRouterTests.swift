//
//  DeepLinkRouterTests.swift
//  NavigationTests
//

import Testing
import Foundation
@testable import Navigation

@MainActor
struct DeepLinkRouterTests {

    @Test func resolvesUsingTheMapperThatMatchesTheURL() {
        let router = DeepLinkRouter(mappers: [
            StubMapper(host: "featureA", route: AnyRoute(DummyRoute.main)),
            StubMapper(host: "featureB", route: AnyRoute(DummyRoute.detail(id: "1"))),
        ])

        let resolved = router.resolve(url: URL(string: "myapp://featureB/path")!)
        #expect(resolved == AnyRoute(DummyRoute.detail(id: "1")))
    }

    @Test func returnsNilWhenNoMapperMatches() {
        let router = DeepLinkRouter(mappers: [
            StubMapper(host: "featureA", route: AnyRoute(DummyRoute.main)),
        ])

        let resolved = router.resolve(url: URL(string: "myapp://unknown/path")!)
        #expect(resolved == nil)
    }

    @Test func returnsNilWhenThereAreNoMappersAtAll() {
        let router = DeepLinkRouter(mappers: [])
        let resolved = router.resolve(url: URL(string: "myapp://featureA")!)
        #expect(resolved == nil)
    }

    @Test func earlierMapperWinsOverALaterMapperThatWouldAlsoMatch() {
        // Mappers are evaluated in array order; the first non-nil result wins.
        let router = DeepLinkRouter(mappers: [
            StubMapper(host: "shared", route: AnyRoute(DummyRoute.main)),
            StubMapper(host: "shared", route: AnyRoute(DummyRoute.detail(id: "ignored"))),
        ])

        let resolved = router.resolve(url: URL(string: "myapp://shared")!)
        #expect(resolved == AnyRoute(DummyRoute.main))
    }

    @Test func skipsNonMatchingMappersBeforeFindingAMatch() {
        let router = DeepLinkRouter(mappers: [
            StubMapper(host: "featureA", route: AnyRoute(DummyRoute.main)),
            StubMapper(host: "featureC", route: AnyRoute(DummyRoute.detail(id: "irrelevant"))),
            StubMapper(host: "featureB", route: AnyRoute(DummyRoute.detail(id: "2"))),
        ])

        let resolved = router.resolve(url: URL(string: "myapp://featureB")!)
        #expect(resolved == AnyRoute(DummyRoute.detail(id: "2")))
    }
}
