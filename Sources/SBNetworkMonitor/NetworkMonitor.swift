import Network

// MARK: - Network Monitor

/// An observer that you use to monitor and react to network changes.
public struct NetworkMonitor {
    
    public struct Connection {
        fileprivate let path: NWPath
    }
    
    private let monitor: NWPathMonitor
}

public extension NetworkMonitor {
    
    /// Initializes a network monitor that receives updates on the specified queue.
    init(
        queue: DispatchQueue = .global(),
        requiredInterfaceType: NWInterface.InterfaceType? = nil,
        updateHandler: @escaping (Connection) -> Void) {
        
        monitor = Self.makeMonitor(requiredInterfaceType: requiredInterfaceType)
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { updateHandler(Connection(path: $0)) }
    }
    
    /// Stops receiving network updates.
    func cancel() {
        monitor.cancel()
    }
}

private extension NetworkMonitor {
    
    static func makeMonitor(requiredInterfaceType: NWInterface.InterfaceType?) -> NWPathMonitor {
        guard let requiredInterfaceType = requiredInterfaceType else {
            return NWPathMonitor()
        }
        return NWPathMonitor(requiredInterfaceType: requiredInterfaceType)
    }
}


// MARK: - Connection

public extension NetworkMonitor.Connection {
    
    /// Types of network interfaces, based on their link layer media types.
    enum Interface {
        case wifi, cellular, wiredEthernet, loopback, other
        
        init?(_ type: NWInterface.InterfaceType) {
            switch type {
            case .wifi: self = .wifi
            case .cellular: self = .cellular
            case .wiredEthernet: self = .wiredEthernet
            case .loopback: self = .loopback
            case .other: self = .other
            @unknown default: return nil
            }
        }
    }
    
    /// A list of all interfaces available to the connection, in order of preference.
    var availableInterfaces: [Interface] {
        path.availableInterfaces.compactMap { Interface($0.type) }
    }
    
    /// A Boolean indicating whether the connection is able to send data.
    var isConnected: Bool { path.status == .satisfied }
    
    /// A Boolean indicating whether the connection uses an interface that is considered expensive,
    /// such as Cellular or a Personal Hotspot.
    var isExpensive: Bool { path.isExpensive }
    
    /// A Boolean indicating whether the connection uses an interface in Low Data Mode.
    @available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
    var isConstrained: Bool { path.isConstrained }
    
    /// Checks if this connection may send traffic over a specific interface type.
    func usesInterfaceType(_ type: Interface) -> Bool {
        availableInterfaces.contains(type)
    }
}
