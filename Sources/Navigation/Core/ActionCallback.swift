//
//  ActionCallback.swift
//  Navigation
//
//  Created by ali alhawas on 23/08/2026.
//

/// Wraps a closure so it can ride along on a `Hashable` route/destination
/// without the enclosing enum needing hand-written `Equatable`/`Hashable`
/// conformance.
public final class ActionCallback<Value>: Hashable {
    public let action: (Value) -> Void

    public init(_ action: @escaping (Value) -> Void) {
        self.action = action
    }

    public static func == (lhs: ActionCallback, rhs: ActionCallback) -> Bool {
        lhs === rhs
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension ActionCallback where Value == Void {
    public convenience init(_ action: @escaping () -> Void) {
        self.init { _ in action() }
    }

    /// Invokes the wrapped no-argument closure.
    public func fire() {
        action(())
    }
}
