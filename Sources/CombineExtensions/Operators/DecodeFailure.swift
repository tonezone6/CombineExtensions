//
//  CatchFailure.swift
//

import Combine
import Foundation

public extension Publisher {
    /**
    In the case of server response with a custom error type,
    you can use this operator to decode that custom error first. */
    func decode<T>(failureType: T.Type, decoder: JSONDecoder = .init()) -> Publishers.TryMap<Self, Data>
    where T: Error, T: Decodable, Output == Data {
        self.tryMap { output in
            if let error = try? decoder.decode(T.self, from: output) {
                throw error
            }
            return output
        }
    }
}
