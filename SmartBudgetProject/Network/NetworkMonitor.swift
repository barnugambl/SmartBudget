//
//  NetworkMonitor.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 03.06.2025.
//

import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
