import Combine
import XCTest
@testable import SBNetworkMonitor

final class NetworkMonitorTests: XCTestCase {
    
    private static var storage = Set<AnyCancellable>()
    
    override class func tearDown() {
        storage = []
    }
    
    // This test requires an internet connection via wifi
    func testNetworkMonitor() {
        
        let valueExpectation = expectation(description: "value")
        
        Publishers.NetworkMonitorPublisher()
            .sink { connection in
                XCTAssertTrue(connection.isConnected)
                XCTAssertFalse(connection.isConstrained)
                XCTAssertFalse(connection.isExpensive)
                XCTAssertFalse(connection.usesInterfaceType(.wiredEthernet))
                XCTAssertFalse(connection.usesInterfaceType(.cellular))
                XCTAssertFalse(connection.usesInterfaceType(.loopback))
                XCTAssertFalse(connection.usesInterfaceType(.other))
                valueExpectation.fulfill()
            }
            .store(in: &Self.storage)
        
        waitForExpectations(timeout: 0.5)
    }
    
    // This test will fail if connected to cellular network
    func testCellularRequired() {
        
        let valueExpectation = expectation(description: "value")
        
        Publishers.NetworkMonitorPublisher(requiredInterfaceType: .cellular)
            .sink { connection in
                XCTAssertFalse(connection.isConnected)
                valueExpectation.fulfill()
            }
            .store(in: &Self.storage)
        
        waitForExpectations(timeout: 0.5)
    }
}
