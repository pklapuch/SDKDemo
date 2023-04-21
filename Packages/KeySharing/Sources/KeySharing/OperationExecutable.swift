//
//  OperationExecutable.swift
//  
//
//  Created by Pawel Klapuch on 4/20/23.
//

import Foundation

protocol OperationExecutorFactory {
    func make(operation: OperationType) -> OperationExecutable
}

protocol OperationExecutable {
    func execute() async
}
