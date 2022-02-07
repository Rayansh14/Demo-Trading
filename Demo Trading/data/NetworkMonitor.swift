//
//  NetworkMonitor.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 23/04/21.
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    
    @Published var isConnected = true
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied ? true: false
            }
        }
        monitor.start(queue: queue)
    }
}
