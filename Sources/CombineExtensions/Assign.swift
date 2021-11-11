
import Combine

extension Publisher {
    
    public func assign<A: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<A, Output>,
        onWeak object: A
    ) -> AnyCancellable where Failure == Never {
    
        self.sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
