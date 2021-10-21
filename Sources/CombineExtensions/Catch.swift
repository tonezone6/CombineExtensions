
import Combine

extension Publisher {
    
    public func `catch`<A, P>(
        assignTo keyPath: ReferenceWritableKeyPath<A, Failure?>,
        on object: A,
        replaceWith placeholder: P
    ) -> Publishers.Catch<Self, AnyPublisher<P, Never>> where A: AnyObject, P == Output {
        
        self.catch { [weak object] error in
            object?[keyPath: keyPath] = error
            return Just(placeholder).eraseToAnyPublisher()
        }
    }
}
