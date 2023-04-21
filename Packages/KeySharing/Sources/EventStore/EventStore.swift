//
//  EventStore.swift
//  
//
//  Created by Pawel Klapuch on 4/20/23.
//

import Foundation

struct Event {
    let eventID: String
    let keyID: String
}

struct LocalEvent {
    let event: Event
    let state: EventState
}

enum EventState {
    case queued
    case completed
    case acknowledged
}

protocol EventStore {
    func insert(_ event: LocalEvent) async throws
    func update(_ event: LocalEvent) async throws
    func loadAll() async thorws -> [LocalEvent]
    func load(with id: UUID) async throws -> LocalEvent
    func delete(with id: UUID) async throws
}
