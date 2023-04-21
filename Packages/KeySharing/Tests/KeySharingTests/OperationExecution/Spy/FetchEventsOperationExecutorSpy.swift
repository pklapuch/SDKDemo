//
//  FetchEventsOperationExecutorSpy.swift
//  
//
//  Created by Pawel Klapuch on 4/20/23.
//

@testable import KeySharing

final class FetchEventsOperationExecutorSpy: OperationExecutable {
    private let stub: Result<Bool, Error>
    private var fetchEventsContinuation: CheckedContinuation<Bool, Error>?
    private(set) var messages = [Message]()
    
    enum Message: Equatable {
        case execute
    }
    
    init(stub: Result<Bool, Error>) {
        self.stub = stub
    }
    
    func stub(fetchEventsContinuation continuation: CheckedContinuation<Bool, Error>) {
        self.fetchEventsContinuation = continuation
    }
    
    func execute() async {
        messages.append(.execute)
        
        await withCheckedContinuation { continuation in
            fetchEventsContinuation?.resume(with: stub)
            continuation.resume()
        }
    }
}
