//
//  NetworkGateway.swift
//  
//
//  Created by Pawel Klapuch on 4/20/23.
//

import Foundation

public protocol NetworkGateway {
    typealias Result = (data: Data, response: HTTPURLResponse)
    
    func execute(request: URLRequest) async throws -> Result
}
