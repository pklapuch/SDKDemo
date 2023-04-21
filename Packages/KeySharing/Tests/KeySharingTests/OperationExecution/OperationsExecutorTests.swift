//
//  OperationsExecutorTests.swift
//  
//
//  Created by Pawel Klapuch on 4/20/23.
//

import XCTest
@testable import KeySharing

final class OperationsExecutorTests: XCTestCase {
    func test_init_doesNotMessageFactory() {
        let (_, factory, _, _, _) = makeSUT()
        XCTAssertEqual(factory.messages, [])
    }
    
    func test_fetchEvents_createsAndExecutesOnce() async throws {
        let (sut, factory, fetchEvents, _, _) = makeSUT()

        _ = try await sut.fetchEvents()

        XCTAssertEqual(factory.messages, [.makeFetchEvents])
        XCTAssertEqual(fetchEvents.messages, [.execute])
        
        _ = try await sut.fetchEvents()
        
        XCTAssertEqual(factory.messages, [.makeFetchEvents, .makeFetchEvents])
        XCTAssertEqual(fetchEvents.messages, [.execute, .execute])
    }
    
    func test_processStoredEvents_createsAndExecutesAndAcknowledgesEventsOnce() async throws {
        let (sut, factory, _, executeEvents, ackEvents) = makeSUT()
        
        await sut.processStoredEvents()
        
        XCTAssertEqual(factory.messages, [.makeExecuteEvents, .makeAcknowledgeEvents])
        XCTAssertEqual(executeEvents.messages, [.execute])
        XCTAssertEqual(ackEvents.messages, [.execute])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: OperationsExecutor,
                                                                             factory: OperationExecutorFactorySpy,
                                                                             fetchEventsOperation: FetchEventsOperationExecutorSpy,
                                                                             executeEventsOperation: OperationExecutorSpy,
                                                                             ackknowledgeEventsOperation: OperationExecutorSpy) {
        let fetchEventsOperation = FetchEventsOperationExecutorSpy(stub: .success(true))
        let executeEventsOperation = OperationExecutorSpy()
        let acknowledgeEventsOperation = OperationExecutorSpy()

        let factory = OperationExecutorFactorySpy(
            fetchEventsOperation: fetchEventsOperation,
            executeEventsOperation: executeEventsOperation,
            acknowledgeEventsOperation: acknowledgeEventsOperation)
        
        let sut = OperationsExecutor(operationExecutorFactory: factory)
        
        trackForMmeoryLeaks(sut)
        trackForMmeoryLeaks(factory)
        trackForMmeoryLeaks(fetchEventsOperation)
        trackForMmeoryLeaks(executeEventsOperation)
        trackForMmeoryLeaks(acknowledgeEventsOperation)
        
        return (sut, factory, fetchEventsOperation, executeEventsOperation, acknowledgeEventsOperation)
    }
}
