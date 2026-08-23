//
//  ActionCallback.swift
//  Navigation
//

/// Wraps a closure so it can ride along on a `Hashable` route/destination
/// without the enclosing enum needing hand-written `Equatable`/`Hashable`
/// conformance.
///
/// Equality/hashing are by reference identity (`===`/`ObjectIdentifier`),
/// never by what `action` does or what `Value` is — two callbacks are only
/// ever equal if they're literally the same instance. That's enough for a
/// route/destination carrying one (or several) of these to go back to
/// plain, compiler-synthesized `Hashable` conformance, which can't silently
/// go stale the way a hand-written `switch` with a `default:` case can when
/// a new case is added later.
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
