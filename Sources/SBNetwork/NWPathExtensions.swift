import Network

public extension NWPath {
    
    /// A Boolean indicating whether the path is able to send data.
    /// - Author: Scott Brenner | SBNetwork
    var isConnected: Bool { status == .satisfied }
    
    /// The interface type over which the path may send traffic.
    /// - Author: Scott Brenner | SBNetwork
    var connectionType: NWInterface.InterfaceType {
        let connectionTypes: [NWInterface.InterfaceType] = [.cellular, .wifi, .wiredEthernet]
        return connectionTypes.first(where: usesInterfaceType) ?? .other
    }
}
