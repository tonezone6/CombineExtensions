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
        Publisher(monitor: self)
    }
    
    private class Subscription<S: Subscriber>: Combine.Subscription where S.Input == NWPath {
        let subscriber: S
        let monitor: NWPathMonitor
        
        private var started = false
        
        init(subscriber: S, monitor: NWPathMonitor) {
            self.subscriber = subscriber
            self.monitor = monitor
        }

        /// This subscription only supports
        /// demand unlimited
        func request(_ demand: Subscribers.Demand) {
            guard !started else { return }
            started = true
            
            monitor.pathUpdateHandler = { [unowned self] path in
                _ = subscriber.receive(path)
            }
            monitor.start(queue: .main)
        }
        
        func cancel() {
            monitor.cancel()
        }
    }
    
    public struct Publisher: Combine.Publisher {
        public typealias Output = NWPath
        public typealias Failure = Never
        
        let monitor: NWPathMonitor
        
        public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = Subscription(subscriber: subscriber, monitor: monitor)
            subscriber.receive(subscription: subscription)
        }
    }
}
