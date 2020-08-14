import Network

public extension NWPath {
    
    /// A Boolean indicating whether the path is able to send data.
    /// - Author: Scott Brenner | SBNetwork
    var isConnected: Bool { status == .satisfied }
}
