import SwiftUI
import SystemInfoKit

struct SystemInfoPrimary: View {
	private let data = SystemInfoData.shared

	@Binding var expand: Bool

	var body: some View {
		let info: SystemInfoBundle = data.systemInfo

		HStack {
			if let cpu = info.cpuInfo {
				HStack {
					Image(systemName: cpu.icon)
					// Text("CPU:")
					Text(cpu.usage.description)
						.animatedNumbers(value: cpu.usage.value)
					// Text("System:")
					// Text(cpu.system.description)
					// Text("User:")
					// Text(cpu.user.description)
					// Text("Idle:")
					// Text(cpu.idle.description)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
			}
			if let memory = info.memoryInfo {
				HStack {
					Image(systemName: memory.icon)
					// Text("Memory:")
					Text(memory.usage.description)
						.animatedNumbers(value: memory.usage.value)
					// Text("Pressure:")
					// Text(memory.pressure.description)
					// Text("App:")
					// Text(memory.appMemory.description)
					// Text("Wired:")
					// Text(memory.wiredMemory.description)
					// Text("Compressed:")
					// Text(memory.compressed.description)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
			}
			if let storage = info.storageInfo {
				HStack {
					Image(systemName: storage.icon)
					// Text("Storage:")
					Text(storage.usage.description)
						.animatedNumbers(value: storage.usage.value)
					// Text("Used:")
					// Text(storage.used.description)
					// Text("Free:")
					// Text(storage.free.description)
					// Text("Total:")
					// Text(storage.total.description)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
			}
			if let battery = info.batteryInfo {
				HStack {
					Image(systemName: battery.icon)
					// Text("Battery:")
					// Text(battery.amount.description)
					// Text("Power Source:")
					// Text(battery.source)
					// Text("Max Capacity:")
					// Text(battery.capacity.description)
					// Text("Cycle Count:")
					Text(battery.cycles.description)
						.animatedNumbers(value: battery.cycles.value)
					// Text("Temperature:")
					// Text(battery.temperature.description)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
			}
			if let network = info.networkInfo {
				HStack {
					Image(systemName: network.icon)
					// Text("Network:")
					// Text(network.name)
					Text(network.ip)
						.monospacedDigit()
					// Text(network.upload.value.description)
					// Text(network.download.value.description)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
			}
		}
		.padding(.leading, 4)
		.padding(.vertical, 4)
		.frame(maxWidth: .infinity, alignment: .leading)
	}
}

#Preview {
	@Previewable @State var expand: Bool = true
	SystemInfoPrimary(expand: $expand)
}

/* UpdateSystemInfo

CPU: 10.3%
	System:  3.3%
	User:  6.9%
	Idle: 89.7%
Memory: 58.7%
	Pressure:  9.5%
	App Memory: 15.7 GB
	Wired Memory:  1.9 GB
	Compressed:  1.1 GB
Storage: 16.1% used
	79.61 GB / 494.38 GB
Battery: 100.0%
	Power Source: Battery
	Max Capacity: 100.0%
	Cycle Count: 16
	Temperature: 30.6℃
Network: USB 10/100/1G/2.5G LAN
	Local IP: 192.168.1.64
	Upload:   0.0 KB/s
	Download:   0.0 KB/s
*/
