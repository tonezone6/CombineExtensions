
import Combine

extension Publisher {
    
    public func weakAssign<A: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<A, Output>,
        on object: A
    ) -> AnyCancellable where Failure == Never {
    
        self.sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
    
    public func assign<A>(
        to result: ReferenceWritableKeyPath<A, Output>,
        and failure: ReferenceWritableKeyPath<A, Failure?>,
        on object: A
    ) -> AnyCancellable where A: AnyObject {

        self.sink(
            receiveCompletion: { [weak object] completion in
                if case let .failure(error) = completion {
                    object?[keyPath: failure] = error
                }
            }, receiveValue: { [weak object] value in
                object?[keyPath: result] = value
            }
        )
    }
}
