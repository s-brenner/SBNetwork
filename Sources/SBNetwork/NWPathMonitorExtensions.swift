import Combine
import Network

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
public extension NWPathMonitor {
    
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
            
            let subscription = PathSubscription(
                subscriber: subscriber,
                monitor: monitor,
                queue: .global(qos: .background)
            )
            subscriber.receive(subscription: subscription)
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
fileprivate extension NWPathMonitor {
    
    class PathSubscription<S: Subscriber>: Subscription
    where S.Input == NWPath {
            
        private var subscriber: S?
        
        private let monitor: NWPathMonitor
        
        fileprivate init(subscriber: S, monitor: NWPathMonitor, queue: DispatchQueue) {
            self.subscriber = subscriber
            self.monitor = monitor
            startMonitor(on: queue)
        }
        
        func request(_ demand: Subscribers.Demand) { }
        
        func cancel() {
            monitor.cancel()
            subscriber = nil
        }
        
        func startMonitor(on queue: DispatchQueue) {
            monitor.start(queue: queue)
            monitor.pathUpdateHandler = { [weak self] path in
                _ = self?.subscriber?.receive(path)
            }
        }
    }
}
