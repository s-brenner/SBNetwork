import Combine
import Network

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
public extension NWPathMonitor {
    
    /// A publisher that you use to monitor and react to network changes..
    /// - Author: Scott Brenner | SBNetwork
    struct Publisher: Combine.Publisher {
        
        public typealias Output = NWPath
        
        public typealias Failure = Never
        
        private let monitor: NWPathMonitor
        
        public init() {
            monitor = NWPathMonitor()
        }
        
        public init(requiredInterfaceType type: NWInterface.InterfaceType) {
            monitor = NWPathMonitor(requiredInterfaceType: type)
        }
        
        @available(iOS 14.0, tvOS 14.0, macOS 10.16, *)
        public init(prohibitedInterfaceTypes types: [NWInterface.InterfaceType]) {
            monitor = NWPathMonitor(prohibitedInterfaceTypes: types)
        }
        
        public func receive<S>(subscriber: S)
            where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            
            let subscription = Inner(
                subscriber: subscriber,
                monitor: monitor,
                queue: .global(qos: .background)
            )
            subscriber.receive(subscription: subscription)
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
extension NWPathMonitor.Publisher {
    
    class Inner<Downstream: Subscriber>: Subscription
    where Downstream.Input == NWPath {
            
        private var downstream: Downstream?
        
        private let monitor: NWPathMonitor
        
        private let queue: DispatchQueue
        
        fileprivate init(subscriber: Downstream, monitor: NWPathMonitor, queue: DispatchQueue) {
            self.downstream = subscriber
            self.monitor = monitor
            self.queue = queue
        }
        
        func request(_ demand: Subscribers.Demand) {
            guard demand > 0 else { return }
            monitor.start(queue: queue)
            monitor.pathUpdateHandler = { [weak self] path in
                _ = self?.downstream?.receive(path)
            }
        }
        
        func cancel() {
            monitor.cancel()
            downstream = nil
        }
    }
}
