//
//  SharingInvitation.swift
//  
//
//  Created by Pawel Klapuch on 4/20/23.
//

import Foundation

public struct SharingInvitation {
    let sessionID: String
    let prKey: Data
    
    public init(sessionID: String, prKey: Data) {
        self.sessionID = sessionID
        self.prKey = prKey
    }
    
    public init(sharingURL: String) throws {
        throw NSError(domain: "", code: 0)
    }
}
