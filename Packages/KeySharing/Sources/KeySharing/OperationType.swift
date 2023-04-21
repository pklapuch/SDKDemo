//
//  OperationType.swift
//  
//
//  Created by Pawel Klapuch on 4/20/23.
//

import Foundation

typealias FetchEventsContinuation = CheckedContinuation<Bool, Swift.Error>

enum OperationType {
    case fetchEvents(FetchEventsContinuation)
    case executeEvents
    case acknowledgeEvents
}
