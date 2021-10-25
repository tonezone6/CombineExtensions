
import Combine

extension Publisher {
    
    public func `catch`<A, P>(
        to keyPath: ReferenceWritableKeyPath<A, Failure?>,
        onWeak object: A,
        replaceWith placeholder: P
    ) -> Publishers.Catch<Self, AnyPublisher<P, Never>> where A: AnyObject, P == Output {
        
        self.catch { [weak object] error in
            object?[keyPath: keyPath] = error
            return Just(placeholder).eraseToAnyPublisher()
        }
    }
}
