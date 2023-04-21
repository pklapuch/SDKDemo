import Combine
import NetworkHelper
import Foundation

public final actor KeySharing {
    private let _sharingSessions = CurrentValueSubject<[SharingSession], Never>([])
    
    public var sharingSessions: AnyPublisher<[SharingSession], Never> {
        _sharingSessions.eraseToAnyPublisher()
    }
    
    private let networkGateway: NetworkGateway
    private var running = false
    
    public init(networkGateway: NetworkGateway) {
        self.networkGateway = networkGateway
    }
    
    public func start() async {
        guard !running else { return }
        
        running = true
    }
    
    public func stop() async {
        guard running else { return }
        
        //await stop
        
        running = false
    }
    
    public func fetchEvents() async throws -> Bool {
        return false
    }
    
    public func scheduleSharingSession(_ sharingURL: String) async throws {
        
    }
    
    public func cancelSharingSession(_ sharingURL: String) async throws {
        
    }
}


// Fetch evnets
// Execute events
