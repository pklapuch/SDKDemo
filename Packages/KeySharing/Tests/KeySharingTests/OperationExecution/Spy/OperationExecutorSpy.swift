//
//  OperationExecutorSpy.swift
//  
//
//  Created by Pawel Klapuch on 4/20/23.
//

import Foundation
@testable import KeySharing

final class OperationExecutorSpy: OperationExecutable {
    private(set) var messages = [Message]()
    
    enum Message: Equatable {
        case execute
    }
    
    func execute() async {
        messages.append(.execute)
    }
}
