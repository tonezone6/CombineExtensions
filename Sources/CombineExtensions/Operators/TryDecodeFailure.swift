//
//  CatchFailure.swift
//

import Combine
import Foundation

public extension Publisher {
    /**
    Custom decodable error type */
    func tryDecode<Failure>(failure: Failure.Type,
                            decoder: JSONDecoder = .init()) -> Publishers.TryMap<Self, Data>
    where Failure: Error, Failure: Decodable, Output == Data {
        self.tryMap { data in
            if let error = try? decoder.decode(Failure.self, from: data) {
                throw error
            } else {
                return data
            }
        }
    }
}
