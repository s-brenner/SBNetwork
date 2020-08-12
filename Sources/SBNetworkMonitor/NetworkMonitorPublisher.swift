import Combine
import Network
@_exported import enum Combine.Publishers

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
extension Subscriptions {
    
    final class NetworkMonitorSubscription<S: Subscriber>: Subscription
    where S.Input == NetworkMonitor.Connection {
        
        private var subscriber: S?
        
        private let monitor: NetworkMonitor
        
        fileprivate init(subscriber: S, queue: DispatchQueue, requiredInterfaceType: NWInterface.InterfaceType?) {
            self.subscriber = subscriber
            monitor = NetworkMonitor(queue: queue, requiredInterfaceType: requiredInterfaceType) {
                _ = subscriber.receive($0)
            }
        }
        
        func request(_ demand: Subscribers.Demand) { }
        
        func cancel() {
            monitor.cancel()
            subscriber = nil
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
public extension Publishers {
    
    struct NetworkMonitorPublisher: Publisher {
        
        public typealias Output = NetworkMonitor.Connection
        
        public typealias Failure = Never
        
        private let requiredInterfaceType: NWInterface.InterfaceType?
        
        public init(requiredInterfaceType: NWInterface.InterfaceType? = nil) {
            self.requiredInterfaceType = requiredInterfaceType
        }
        
        public func receive<S>(subscriber: S)
            where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            
            let subscription = Subscriptions.NetworkMonitorSubscription(
                subscriber: subscriber,
                queue: .global(),
                requiredInterfaceType: requiredInterfaceType
            )
            subscriber.receive(subscription: subscription)
        }
    }
}
