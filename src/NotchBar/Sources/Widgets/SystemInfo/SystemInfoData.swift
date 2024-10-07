import SystemInfoKit
import Combine
import Observation

@Observable final class SystemInfoData {
	static let shared = SystemInfoData()
	
	private(set) var systemInfo = SystemInfoBundle()
	
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
