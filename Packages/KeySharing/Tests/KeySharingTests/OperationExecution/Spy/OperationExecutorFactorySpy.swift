//
//  OperationExecutorFactorySpy.swift
//  
//
//  Created by Pawel Klapuch on 4/20/23.
//

import Foundation
@testable import KeySharing

final class OperationExecutorFactorySpy: OperationExecutorFactory {
    let fetchEventsOperation: FetchEventsOperationExecutorSpy
    let executeEventsOperation: OperationExecutorSpy
    let acknowledgeEventsOperation: OperationExecutorSpy
    
    private(set) var messages = [Message]()
    
    enum Message: Equatable {
        case makeFetchEvents
        case makeExecuteEvents
        case makeAcknowledgeEvents
    }
    
    init(fetchEventsOperation: FetchEventsOperationExecutorSpy,
         executeEventsOperation: OperationExecutorSpy,
         acknowledgeEventsOperation: OperationExecutorSpy) {
        
        self.fetchEventsOperation = fetchEventsOperation
        self.executeEventsOperation = executeEventsOperation
        self.acknowledgeEventsOperation = acknowledgeEventsOperation
    }
    
    func make(operation: OperationType) -> OperationExecutable {
        switch operation {
        case let .fetchEvents(continuation):
            fetchEventsOperation.stub(fetchEventsContinuation: continuation)
            messages.append(.makeFetchEvents)
            return fetchEventsOperation
        case .executeEvents:
            messages.append(.makeExecuteEvents)
            return executeEventsOperation
        case .acknowledgeEvents:
            messages.append(.makeAcknowledgeEvents)
            return acknowledgeEventsOperation
        }
    }
}
