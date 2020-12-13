import Combine

@available(iOS 13.0, *)
public class NetworkMonitor: ObservableObject {
    
    @Published public var isConnected = false
    
    @Published public var isExpensive = false
    
    @Published public var isConstrained = false
    
    @Published public var connectionType = NWInterface.InterfaceType.other
    
    private let publisher: NWPathMonitor.Publisher
    
    private var storage = Set<AnyCancellable>()
    
    public init() {
        publisher = .init()
        sink()
    }
    
    public init(requiredInterfaceType type: NWInterface.InterfaceType) {
        publisher = .init(requiredInterfaceType: type)
        sink()
    }
    
    @available(iOS 14.0, *)
    public init(prohibitedInterfaceTypes types: [NWInterface.InterfaceType]) {
        publisher = .init(prohibitedInterfaceTypes: types)
        sink()
    }
}

@available(iOS 13.0, *)
private extension NetworkMonitor {
    
    func sink() {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] path in
                self?.isConnected = path.isConnected
                self?.isExpensive = path.isExpensive
                self?.isConstrained = path.isConstrained
                self?.connectionType = path.connectionType
            }
            .store(in: &storage)
    }
}
