//
//  NavigationRouterTests.swift
//  NavigationTests
//

import Testing
import SwiftUI
@testable import Navigation

@MainActor
struct NavigationRouterTests {

    // MARK: - Push

    @Test func navigatePushesOntoAnEmptyStack() {
        let router = NavigationRouter()
        router.navigate(to: DummyRoute.main)
        #expect(router.routes.count == 1)
        #expect(router.routes.first?.matches(DummyRoute.main) == true)
    }

    @Test func navigatePushesInCallOrder() {
        let router = NavigationRouter()
        router.navigate(to: DummyRoute.main)
        router.navigate(to: DummyRoute.detail(id: "1"))
        #expect(router.routes.count == 2)
        #expect(router.routes[0].matches(DummyRoute.main))
        #expect(router.routes[1].matches(DummyRoute.detail(id: "1")))
    }

    @Test func navigateDefaultsToPushStrategy() {
        let router = NavigationRouter()
        router.navigate(to: DummyRoute.main)
        router.navigate(to: DummyRoute.other)
        #expect(router.routes.count == 2)
    }

    @Test func navigateAcceptsAPreErasedAnyRoute() {
        let router = NavigationRouter()
        router.navigate(to: AnyRoute(DummyRoute.main))
        #expect(router.routes.count == 1)
    }

    // MARK: - Reset stack

    @Test func resetStackReplacesAnExistingStackWithASingleRoute() {
        let router = NavigationRouter()
        router.navigate(to: DummyRoute.main)
        router.navigate(to: DummyRoute.detail(id: "1"))
        router.navigate(to: DummyRoute.other, strategy: .resetStack)
        #expect(router.routes.count == 1)
        #expect(router.routes.first?.matches(DummyRoute.other) == true)
    }

    @Test func resetStackOnAnEmptyStackPushesTheRoute() {
        let router = NavigationRouter()
        router.navigate(to: DummyRoute.main, strategy: .resetStack)
        #expect(router.routes.count == 1)
    }

    // MARK: - popToIfExists

    @Test func popToIfExistsTrimsBackToAnExistingMatch() {
        let router = NavigationRouter()
        router.navigate(to: DummyRoute.main)
        router.navigate(to: DummyRoute.detail(id: "1"))
        router.navigate(to: DummyRoute.other)
        router.navigate(to: DummyRoute.main, strategy: .popToIfExists)
        #expect(router.routes.count == 1)
        #expect(router.routes.first?.matches(DummyRoute.main) == true)
    }

    @Test func popToIfExistsKeepsEverythingUpToAndIncludingTheMatch() {
        let router = NavigationRouter()
        router.navigate(to: DummyRoute.main)
        router.navigate(to: DummyRoute.detail(id: "1"))
        router.navigate(to: DummyRoute.other)
        router.navigate(to: DummyRoute.detail(id: "1"), strategy: .popToIfExists)
        #expect(router.routes.count == 2)
        #expect(router.routes.last?.matches(DummyRoute.detail(id: "1")) == true)
    }

    @Test func popToIfExistsPushesWhenTheRouteIsNotOnTheStack() {
        let router = NavigationRouter()
        router.navigate(to: DummyRoute.main)
        router.navigate(to: DummyRoute.detail(id: "1"), strategy: .popToIfExists)
        #expect(router.routes.count == 2)
        #expect(router.routes.last?.matches(DummyRoute.detail(id: "1")) == true)
    }

    // MARK: - pop

    @Test func popRemovesTheTopRoute() {
        let router = NavigationRouter()
        router.navigate(to: DummyRoute.main)
        router.navigate(to: DummyRoute.detail(id: "1"))
        router.pop()
        #expect(router.routes.count == 1)
        #expect(router.routes.first?.matches(DummyRoute.main) == true)
    }

    @Test func popWithCountRemovesThatManyRoutes() {
        let router = NavigationRouter()
        router.navigate(to: DummyRoute.main)
        router.navigate(to: DummyRoute.detail(id: "1"))
        router.navigate(to: DummyRoute.other)
        router.pop(count: 2)
        #expect(router.routes.count == 1)
        #expect(router.routes.first?.matches(DummyRoute.main) == true)
    }

    @Test func popClampsToTheStackSizeRatherThanTrapping() {
        let router = NavigationRouter()
        router.navigate(to: DummyRoute.main)
        router.navigate(to: DummyRoute.detail(id: "1"))
        router.pop(count: 99)
        #expect(router.routes.isEmpty)
    }

    @Test func popOnAnEmptyStackIsANoOp() {
        let router = NavigationRouter()
        router.pop()
        #expect(router.routes.isEmpty)
    }

    @Test func popWithZeroOrNegativeCountStillPopsExactlyOne() {
        let router = NavigationRouter()
        router.navigate(to: DummyRoute.main)
        router.navigate(to: DummyRoute.detail(id: "1"))
        router.pop(count: 0)
        #expect(router.routes.count == 1)

        router.navigate(to: DummyRoute.detail(id: "2"))
        router.pop(count: -5)
        #expect(router.routes.count == 1)
    }

    // MARK: - popTo(where:)

    @Test func popToWhereTrimsBackToTheLastMatch() {
        let router = NavigationRouter()
        router.navigate(to: DummyRoute.main)
        router.navigate(to: DummyRoute.detail(id: "1"))
        router.navigate(to: DummyRoute.other)
        router.popTo { $0.matches(DummyRoute.main) }
        #expect(router.routes.count == 1)
    }

    @Test func popToWhereMatchesTheLastOccurrenceOfADuplicatedRoute() {
        let router = NavigationRouter()
        router.navigate(to: DummyRoute.main)
        router.navigate(to: DummyRoute.other)
        router.navigate(to: DummyRoute.main)
        router.popTo { $0.matches(DummyRoute.main) }
        // `popTo` uses `lastIndex(where:)`, so it should keep both `.main` entries
        // (index 0 and index 2), not trim back to the first occurrence.
        #expect(router.routes.count == 3)
    }

    @Test func popToWhereIsANoOpWhenNothingMatches() {
        let router = NavigationRouter()
        router.navigate(to: DummyRoute.main)
        router.navigate(to: DummyRoute.detail(id: "1"))
        router.popTo { $0.matches(DummyRoute.other) }
        #expect(router.routes.count == 2)
    }

    // MARK: - popToRoot

    @Test func popToRootClearsTheEntireStack() {
        let router = NavigationRouter()
        router.navigate(to: DummyRoute.main)
        router.navigate(to: DummyRoute.detail(id: "1"))
        router.popToRoot()
        #expect(router.routes.isEmpty)
    }

    @Test func popToRootOnAnEmptyStackIsANoOp() {
        let router = NavigationRouter()
        router.popToRoot()
        #expect(router.routes.isEmpty)
    }

    // MARK: - Sheet presentation

    @Test func presentSheetSetsTheSheetItem() {
        let router = NavigationRouter()
        router.presentSheet(DummyRoute.main)
        #expect(router.sheetItem != nil)
        #expect(router.sheetItem?.route.matches(DummyRoute.main) == true)
    }

    @Test func presentSheetDefaultsToTheRoutesOwnDetents() {
        let router = NavigationRouter()
        router.presentSheet(CustomDetentRoute.screen)
        #expect(router.sheetItem?.configuration.detents == [.medium])
    }

    @Test func presentSheetExplicitDetentsOverrideTheRoutesDefault() {
        let router = NavigationRouter()
        router.presentSheet(DummyRoute.main, detents: [.height(200)])
        #expect(router.sheetItem?.configuration.detents == [.height(200)])
    }

    @Test func presentingASecondSheetReplacesTheFirst() {
        let router = NavigationRouter()
        router.presentSheet(DummyRoute.main)
        router.presentSheet(DummyRoute.other)
        #expect(router.sheetItem?.route.matches(DummyRoute.other) == true)
    }

    @Test func dismissSheetClearsTheSheetItem() {
        let router = NavigationRouter()
        router.presentSheet(DummyRoute.main)
        router.dismissSheet()
        #expect(router.sheetItem == nil)
    }

    @Test func dismissSheetOnAnAlreadyDismissedSheetIsANoOp() {
        let router = NavigationRouter()
        router.dismissSheet()
        #expect(router.sheetItem == nil)
    }

    // MARK: - Full-screen presentation

    @Test func presentFullScreenSetsTheFullScreenRoute() {
        let router = NavigationRouter()
        router.presentFullScreen(DummyRoute.main)
        #expect(router.fullScreenRoute?.matches(DummyRoute.main) == true)
    }

    @Test func dismissFullScreenClearsTheFullScreenRoute() {
        let router = NavigationRouter()
        router.presentFullScreen(DummyRoute.main)
        router.dismissFullScreen()
        #expect(router.fullScreenRoute == nil)
    }

    // MARK: - Independence between instances

    @Test func eachRouterOwnsItsOwnStateIndependently() {
        let a = NavigationRouter()
        let b = NavigationRouter()
        a.navigate(to: DummyRoute.main)
        #expect(a.routes.count == 1)
        #expect(b.routes.isEmpty)
    }
}
