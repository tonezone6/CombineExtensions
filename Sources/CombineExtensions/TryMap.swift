
import Combine
import Foundation

extension Publisher {
    
    public func tryMap<F>(
        failure: F.Type,
        decoder: JSONDecoder = .init()
    ) -> Publishers.TryMap<Self, Data> where F: Error, F: Decodable, Output == Data {
        
        self.tryMap { data in
            if let error = try? decoder.decode(F.self, from: data) {
                throw error
            } else {
                return data
            }
        }
    }
}
