//
//  WeakAssign.swift
//

import Combine

public extension Publisher where Failure == Never {
    func weakAssign<A: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<A, Output>, on object: A) -> AnyCancellable {
        self.sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
