
import Foundation
import Combine

extension Publisher {
    
    public func onReceive(_ handler: @escaping () -> Void) -> Publishers.HandleEvents<Self> {
        self.handleEvents(receiveSubscription: { _ in
            handler()
        })
    }
    
    public func onComplete(_ handler: @escaping () -> Void) -> Publishers.HandleEvents<Self> {
        self.handleEvents(receiveCompletion: { _ in
            DispatchQueue.main.async {
                handler()
            }
        })
    }
}
