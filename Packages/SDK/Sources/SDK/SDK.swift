import KeySharing
import NetworkHelper

public class SDK {
    private let networkGateway: NetworkGateway
    public let keySharing: KeySharing
    
    public init(networkGateway: NetworkGateway) {
        self.networkGateway = networkGateway
        
        keySharing = KeySharing(networkGateway: networkGateway)
    }
}
