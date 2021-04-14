//
//  Unwrap.swift
//

import Combine

extension Publisher {
    func unwrap<Value>() -> Publishers.CompactMap<Self, Value>
    where Output == Optional<Value> {
        self.compactMap { $0 }
    }
}
