//
//  WeakAssign.swift
//

import Combine

/**
 A publisher extension to avoid retain cycle when using `self`
 inspired by John Sundell */

public extension Publisher where Failure == Never {
    
    func weakAssign<A: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<A, Output>, on object: A) -> AnyCancellable {
        
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
