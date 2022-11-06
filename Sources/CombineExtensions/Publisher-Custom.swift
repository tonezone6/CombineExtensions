
import Combine
import Foundation

extension Publisher {
    
    public func update<T: AnyObject>(
        loading keyPath: ReferenceWritableKeyPath<T, Bool>,
        onWeak object: T
    ) -> Publishers.HandleEvents<Self> {
    
        self.handleEvents(receiveSubscription: { [weak object] _ in
            object?[keyPath: keyPath] = true
        }, receiveCompletion: { [weak object] _ in
            object?[keyPath: keyPath] = false
        })
    }
    
    public func `catch`<T, P>(
        to keyPath: ReferenceWritableKeyPath<T, Failure?>,
        onWeak object: T,
        replaceWith placeholder: P
    ) -> Publishers.Catch<Self, AnyPublisher<P, Never>> where T: AnyObject, P == Output {
        
        self.catch { [weak object] error in
            object?[keyPath: keyPath] = error
            return Just(placeholder).eraseToAnyPublisher()
        }
    }
    
    public func assign<T: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<T, Output>,
        onWeak object: T
    ) -> AnyCancellable where Failure == Never {
    
        self.sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
    
    public func sink(
        receiveError: @escaping (Failure) -> Void,
        receiveValue: @escaping (Output) -> Void
    ) -> AnyCancellable {
        self.sink(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                receiveError(error)
            }
        }, receiveValue: { value in
            receiveValue(value)
        })
    }
    
    public func convertToResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.map(Result.success)
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }
    
    public func tryMap<T>(
        failure: T.Type,
        decoder: JSONDecoder = .init()
    ) -> Publishers.TryMap<Self, Data> where T: Error, T: Decodable, Output == Data {
        
        self.tryMap { data in
            if let error = try? decoder.decode(T.self, from: data) {
                throw error
            } else {
                return data
            }
        }
    }
}
