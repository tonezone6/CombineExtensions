
import Combine

extension Publisher {
    
    public func onSubscribe(
        perform handler: @escaping () -> Void
    ) -> Publishers.HandleEvents<Self> {
        
        self.handleEvents(receiveSubscription: { _ in
            handler()
        })
    }
    
    public func onReceive(
        perform handler: @escaping (Output) -> Void
    ) -> Publishers.HandleEvents<Self> {
        
        self.handleEvents(receiveOutput: { output in
            handler(output)
        })
    }
    
    public func onComplete(
        perform handler: @escaping () -> Void
    ) -> Publishers.HandleEvents<Self> {
        
        self.handleEvents(receiveCompletion: { _ in
            handler()
        })
    }
}
