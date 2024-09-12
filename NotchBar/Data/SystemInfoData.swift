//
//  SystemInfoData.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-12.
//

import SystemInfoKit
import Combine

final class SystemInfoData: ObservableObject {
	static let shared = SystemInfoData()
	
	@Published private(set) var systemInfo = SystemInfoBundle()
	
	// Create System Info Observer
	
	private let observer = SystemInfoObserver.shared(monitorInterval: 1.0)
	private var cancellables = Set<AnyCancellable>()
	
	private init() {
		
		// Track System Info
		
		observer.systemInfoPublisher
			.sink { systemInfo in
				self.systemInfo = systemInfo
			}
			.store(in: &cancellables)
		
		observer.startMonitoring()
	}
	
	deinit {
		
		// Stop System Info Observer
		
		observer.stopMonitoring()
	}
}
