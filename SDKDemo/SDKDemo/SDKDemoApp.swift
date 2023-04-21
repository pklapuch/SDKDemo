//
//  SDKDemoApp.swift
//  SDKDemo
//
//  Created by Pawel Klapuch on 4/20/23.
//

import SwiftUI
import NetworkHelper
import SDK

@main
struct SDKDemoApp: App {

    private let sdk: SDK
    
    init() {
        let plainClient = URLSessionNetworkGateway()
        sdk = SDK(networkGateway: plainClient)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await sdk.keySharing.start()
                }
        }
    }
}
