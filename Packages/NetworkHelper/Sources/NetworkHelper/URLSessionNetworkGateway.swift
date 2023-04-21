import Foundation

public class URLSessionNetworkGateway: NetworkGateway {
    private let session: URLSession
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func execute(request: URLRequest) async throws -> NetworkGateway.Result {
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.invalidData
        }
        
        return (data, httpResponse)
    }
}
