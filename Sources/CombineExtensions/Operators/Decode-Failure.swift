//
//  Decode-Failure.swift
//

import Combine
import Foundation

public extension Publisher {
    
    func tryDecodeFailure<F>(type: F.Type, decoder: JSONDecoder) -> Publishers.TryMap<Self, Data>
    where F: Error, F: Decodable, Output == Data {
        
        tryMap { output in
            if let error = try? decoder.decode(F.self, from: output) {
                throw error
            }
            return output
        }
    }
}
