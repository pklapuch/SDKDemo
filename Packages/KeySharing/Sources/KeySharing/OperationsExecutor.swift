//
//  OperationsExecutor.swift
//  
//
//  Created by Pawel Klapuch on 4/20/23.
//

import Foundation

actor OperationsExecutor {
    private let operationExecutorFactory: OperationExecutorFactory
    private var queuedOperations = [OperationType]()
    private var idle = true
    
    init(operationExecutorFactory: OperationExecutorFactory) {
        self.operationExecutorFactory = operationExecutorFactory
    }
    
    func fetchEvents() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            queuedOperations.append(.fetchEvents(continuation))
            checkState()
        }
    }
    
    func processStoredEvents() async  {
        queuedOperations.append(.executeEvents)
        queuedOperations.append(.acknowledgeEvents)
        await startNextOperationIfIdle()
    }
    
    private func checkState() {
        Task {
            await startNextOperationIfIdle()
        }
    }
    
    private func startNextOperationIfIdle() async {
        guard idle else { return }
        guard !queuedOperations.isEmpty else { return }
        
        idle = false
        while !queuedOperations.isEmpty {
            await startOperation(queuedOperations.removeFirst())
        }
        idle = true
        
        checkState()
    }
    
    private func startOperation(_ operation: OperationType) async {
        let executor = operationExecutorFactory.make(operation: operation)
        await executor.execute()
    }
}
