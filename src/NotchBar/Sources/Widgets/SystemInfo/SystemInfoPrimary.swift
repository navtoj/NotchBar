/* UpdateSystemInfo

 CPU: 10.3%						 - cpu.usage.description
 System:  3.3%				 - cpu.system.description
 User:  6.9%					 - cpu.user.description
 Idle: 89.7%					 - cpu.idle.description

 Memory: 58.7%					 - memory.usage.description
 Pressure:  9.5%				 - memory.pressure.description
 App Memory: 15.7 GB			 - memory.appMemory.description
 Wired Memory:  1.9 GB		 - memory.wiredMemory.description
 Compressed:  1.1 GB			 - memory.compressed.description

 Storage: 16.1% used				 - storage.usage.description
 79.61 GB / 494.38 GB			 - storage.free/used/total.description

 Battery: 100.0%					 - battery.amount.description
 Power Source: Battery		 - battery.source
 Max Capacity: 100.0%		 - battery.capacity.description
 Cycle Count: 16				 - battery.cycles.description
 Temperature: 30.6℃			 - battery.temperature.description

 Network: USB 10/100/1G/2.5G LAN	 - network.name
 Local IP: 192.168.1.64		 - network.ip
 Upload:   0.0 KB/s			 - network.upload.value.description
 Download:   0.0 KB/s		 - network.download.value.description
 */

import SwiftUI
import SystemInfoKit

struct SystemInfoPrimary: PrimaryViewType {
	static let id = "SystemInfoPrimary"
	private let data = SystemInfoData.shared

	@Binding var expand: Bool

	var body: some View {
		let info: SystemInfoBundle = data.systemInfo

		HStack {
			Group {
				if let cpu = info.cpuInfo {
					HStack {
						Image(systemName: cpu.icon)
						Text(cpu.usage.description)
							.animatedNumbers(value: cpu.usage.value)
					}
				}
				if let memory = info.memoryInfo {
					HStack {
						Image(systemName: memory.icon)
						Text(memory.usage.description)
							.animatedNumbers(value: memory.usage.value)
					}
				}
				if let storage = info.storageInfo {
					HStack {
						Image(systemName: storage.icon)
						Text(storage.usage.description)
							.animatedNumbers(value: storage.usage.value)
					}
				}
				if let battery = info.batteryInfo {
					HStack {
						Image(systemName: battery.icon)
						Text(battery.cycles.description)
							.animatedNumbers(value: battery.cycles.value)
					}
				}
				if let network = info.networkInfo {
					HStack {
						Image(systemName: network.icon)
						Text(network.ip)
							.monospacedDigit()
					}
				}
			}
			.modifier(InfoTile())
		}
//		.padding(.leading, 4)
//		.padding(.vertical, 4)
//		.frame(maxWidth: .infinity, alignment: .leading)
	}
}

#Preview {
	@Previewable @State var expand: Bool = true
	SystemInfoPrimary(expand: $expand)
}

private struct InfoTile: ViewModifier {
	func body(content: Content) -> some View {
		content
			.padding(.horizontal, 4)
			.padding(.vertical, 2)
			.background(.fill)
			.roundedCorners(7, type: .circular)
	}
}
