
import Combine
import Foundation

extension Publisher {
    
    public func tryMap<E>(
        failure: E.Type,
        decoder: JSONDecoder = .init()
    ) -> Publishers.TryMap<Self, Data> where E: Error, E: Decodable, Output == Data {
        
        self.tryMap { data in
            if let error = try? decoder.decode(E.self, from: data) {
                throw error
            } else {
                return data
            }
        }
    }
}
