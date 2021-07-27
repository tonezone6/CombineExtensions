//
//  File.swift
//  
//
//  Created by Alex Stratu on 27.07.2021.
//

import Combine
import Network

extension NWPathMonitor {
    public var publisher: NWPathMonitor.Publisher {
        Publisher(monitor: self, queue: DispatchQueue.global(qos: .background))
    }
    
    private class Subscription<S: Subscriber>: Combine.Subscription where S.Input == NWPath {
        let subscriber: S
        let monitor: NWPathMonitor
        let queue: DispatchQueue
        
        private var started = false
        
        init(subscriber: S, monitor: NWPathMonitor, queue: DispatchQueue) {
            self.subscriber = subscriber
            self.monitor = monitor
            self.queue = queue
        }

        /// This subscription only supports
        /// demand unlimited
        func request(_ demand: Subscribers.Demand) {
            guard !started else { return }
            started = true
            
            monitor.pathUpdateHandler = { [unowned self] path in
                _ = subscriber.receive(path)
            }
            monitor.start(queue: queue)
        }
        
        func cancel() {
            monitor.cancel()
        }
    }
    
    public struct Publisher: Combine.Publisher {
        public typealias Output = NWPath
        public typealias Failure = Never
        
        let monitor: NWPathMonitor
        let queue: DispatchQueue
        
        public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = Subscription(subscriber: subscriber, monitor: monitor, queue: queue)
            subscriber.receive(subscription: subscription)
        }
    }
}
