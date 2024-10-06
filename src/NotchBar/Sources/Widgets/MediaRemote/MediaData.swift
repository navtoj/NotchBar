import AppKit

@Observable
final class MediaData {
#if DEBUG
	private let debug = false
#else
	private let debug = false
#endif
	static let shared = MediaData()
	
	private(set) var application: NSRunningApplication?
	private(set) var isPlaying: Bool = false
	private(set) var track: Track?
	
	private init() {
		if debug { print("MediaData") }
		
		// Register For Now Playing Notifications
		
		MRMediaRemoteRegisterForNowPlayingNotifications(DispatchQueue.main);
		
		// Get Current Information
		
		fetchApplication()
		fetchIsPlaying()
		fetchNowPlayingInfo()
		
		// Track Application
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handleApplicationDidChangeNotification),
			name: Notification.Name("kMRMediaRemoteNowPlayingApplicationDidChangeNotification"),
			object: nil
		)
		
		// Track Is Playing
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handleApplicationIsPlayingDidChangeNotification),
			name: Notification.Name("kMRMediaRemoteNowPlayingApplicationIsPlayingDidChangeNotification"),
			object: nil
		)
		
		// Track Playback
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handlePlaybackQueueChangedNotification),
			name: Notification.Name("kMRNowPlayingPlaybackQueueChangedNotification"),
			object: nil
		)
		
		// Track Artwork
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handleInfoDidChangeNotification),
			name: Notification.Name("kMRMediaRemoteNowPlayingInfoDidChangeNotification"),
			object: nil
		)
	}
	
	@objc private func handleApplicationDidChangeNotification(_ notification: Notification) {
//		if debug { print("\n// " + "handleApplicationDidChangeNotification") }
		
		// Get Notification Information
		
		if let info = notification.userInfo as? [String: Any] {
			let application = getApplication(from: info)
			if debug { print(application) }
		}
	}
	
	@objc private func handleApplicationIsPlayingDidChangeNotification(_ notification: Notification) {
//		if debug { print("\n// " + "handleApplicationIsPlayingDidChangeNotification") }
		
		// Get Notification Information
		
		if let info = notification.userInfo as? [String: Any] {
			let isPlaying = getIsPlaying(from: info)
			if debug { print(isPlaying, self.isPlaying ? "Playing" : "Paused") }
		}
	}
	
	@objc private func handlePlaybackQueueChangedNotification(_ notification: Notification) {
//		if debug { print("\n// " + "handlePlaybackQueueChangedNotification") }
		
		// Get Notification Information
		
		if let info = notification.userInfo as? [String: Any] {
			if let origin = info["_MROriginatingNotification"] as? String {
				
				// make sure notification does not overlap with other handlers
				if ![
					"_MRMediaRemoteOriginNowPlayingApplicationDidChangeNotification",
				].contains(origin) {
					
					// make sure notification is relevant
					if origin == "_kMRNowPlayingPlaybackQueueChangedNotification" {
						
						// try to get now playing info from notification but force update if not found
						let nowPlaying = getNowPlaying(from: info)
						if !nowPlaying {
							if debug { print("Fetching...") }
							fetchNowPlayingInfo()
						}
					} else {
						if debug { print("> origin :", origin) }
						if debug { print(info) }
					}
				}
			}
		}
	}
	
	@objc private func handleInfoDidChangeNotification(_ notification: Notification) {
//		if debug { print("\n// " + "handleInfoDidChangeNotification") }
		
		// Get Notification Information
		
		if let info = notification.userInfo as? [String: Any] {
			if let origin = info["_MROriginatingNotification"] as? String {
				if ![
					"_MRMediaRemoteOriginNowPlayingApplicationDidChangeNotification",
					"_MRMediaRemotePlayerIsPlayingDidChangeNotification",
					"_kMRNowPlayingPlaybackQueueChangedNotification",
					"_MRPlayerPlaybackQueueContentItemArtworkChangedNotification"
				].contains(origin) {
					if debug { print("Unknown Origin:", origin) }
				}
			} else { if debug { print("No origin found.") } }
		}
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
		MRMediaRemoteUnregisterForNowPlayingNotifications()
	}
	
	private func fetchApplication() {
		if debug { print("\n" + "fetchApplication") }
		
		MRMediaRemoteGetNowPlayingApplicationPID(DispatchQueue.main, { (pid) in
			let app = NSRunningApplication(processIdentifier: pid_t(pid))
			
			if self.debug { print("fetchApplication :", app?.bundleIdentifier ?? (pid == 0 ? "nil" : pid)) }
			
			self.application = app
		})
	}
	
	private func fetchIsPlaying() {
		if debug { print("\n" + "fetchIsPlaying") }
		
		MRMediaRemoteGetNowPlayingApplicationIsPlaying(DispatchQueue.main, { (isPlaying) in
			if self.debug { print("fetchIsPlaying :", isPlaying ? "Playing" : "Paused") }
			
			self.isPlaying = isPlaying
		})
	}
	
	private func fetchNowPlayingInfo() {
		if debug { print("\n" + "fetchNowPlayingInfo") }
		
		MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main, { (information) in
			if
				let artist = information["kMRMediaRemoteNowPlayingInfoArtist"] as? String,
				let title = information["kMRMediaRemoteNowPlayingInfoTitle"] as? String,
				let album = information["kMRMediaRemoteNowPlayingInfoAlbum"] as? String,
				let duration = information["kMRMediaRemoteNowPlayingInfoDuration"] as? TimeInterval,
				let elapsedTime = information["kMRMediaRemoteNowPlayingInfoElapsedTime"] as? TimeInterval
			{
				if self.debug { print("fetchNowPlayingInfo :", title) }
				
				var artworkId: String? = nil
				var artworkData: Data? = nil
				if
					let identifier = information["kMRMediaRemoteNowPlayingInfoArtworkIdentifier"] as? String,
					let data = information["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data
				{
					artworkId = identifier
					artworkData = data
				}
				
				self.updateNowPlayingInfo(
					artist: artist,
					title: title,
					album: album,
					duration: duration,
					elapsedTime: elapsedTime,
					artworkId: artworkId,
					artworkData: artworkData
				)
			} else {
				self.track = nil
				if self.debug { print("fetchNowPlayingInfo :", self.track ?? "nil") }
			}
		})
	}
	
	private func getApplication(from info: [String: Any]) -> Bool {
		if debug { print("\n" + "getApplication") }
		
		if let appInfo = info["kMRNowPlayingClientUserInfoKey"] as? AnyObject {
			if let bundleIdentifier = appInfo.bundleIdentifier as? String {
				let appsFound = NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier)
				if appsFound.count == 1 {
					let appFound = appsFound.first
					if let app = appFound {
						application = app
						
						// if app was found
						return true
					} else { if debug { print("No app found.") } }
				} else if (appsFound.count == 0) { if debug { print("No apps found.") } }
				else { if debug { print("Multiple apps found:", appsFound) } }
			} else { if debug { print("No bundleIdentifier property.") } }
		} else { if debug { print("No appInfo property.") } }
		
		// if no app was found
		return false
	}
	
	private func getIsPlaying(from info: [String: Any]) -> Bool {
		if debug { print("\n" + "getIsPlaying") }
		
		if let isPlaying = info["kMRMediaRemoteNowPlayingApplicationIsPlayingUserInfoKey"] as? boolean_t {
			self.isPlaying = isPlaying == 1
			
			// if isPlaying was found
			return true
		} else { if debug { print("No isPlaying property.") } }
		
		// if isPlaying was not found
		return false
	}
	
	private func getNowPlaying(from info: [String: Any]) -> Bool {
		if debug { print("\n" + "getNowPlaying") }
		
		if let updatedContentItems = info["kMRMediaRemoteUpdatedContentItemsUserInfoKey"] as? [AnyObject] {
			if let updatedContent = updatedContentItems.first {
				if let metadata = updatedContent.value(forKey: "metadata") as? AnyObject {
					if
						let artist = metadata.value(forKey: "trackArtistName") as? String,
						let title = metadata.value(forKey: "title") as? String,
						let album = metadata.value(forKey: "albumName") as? String,
						let duration = metadata.value(forKey: "duration") as? TimeInterval,
						let elapsedTime = metadata.value(forKey: "elapsedTime") as? TimeInterval,
						let artworkId = metadata.value(forKey: "artworkIdentifier") as? String
					{
						if debug { print("getNowPlayingInfo :", title) }
						
						updateNowPlayingInfo(
							artist: artist,
							title: title,
							album: album,
							duration: duration,
							elapsedTime: elapsedTime,
							artworkId: artworkId,
							artworkData: nil
						)
						
						// if nowPlaying was found
						return true
					} else { if debug { print("Invalid metadata.") } }
				} else { if debug { print("No metadata property.") } }
			} else { if debug { print("No data item.") } }
		} else { if debug { print("No data array.") } }
		
		// if nowPlaying was not found
		return false
	}
	
	private func updateNowPlayingInfo(artist: String, title: String, album: String, duration: TimeInterval, elapsedTime: TimeInterval, artworkId: String?, artworkData: Data?) {
		if debug { print("updateNowPlayingInfo") }
		
		// Store Track Artwork Data
		
		var artworkData: Data? = artworkData
		
		// If No Artwork Data, Find Existing Artwork Data
		
		if artworkData == nil,
		   let artworkId = artworkId,
		   let track = track,
		   let currentArtworkId = track.artworkId,
		   artworkId == currentArtworkId,
		   let currentArtworkData = track.artworkData
		{
			if debug { print("Using existing artwork data.") }
			artworkData = currentArtworkData
		}
		
		// Create Track
		
		let track = Track(
			artist: artist,
			title: title,
			album: album,
			duration: duration,
			elapsedTime: elapsedTime,
			artworkId: artworkId,
			artworkData: artworkData
		)
		
		// Update Track
		
		if let current = self.track, current == track {
			let updated = current.update(using: track)
			if debug && !updated.isEmpty { print("Updated Track :", updated) }
		} else {
			self.track = track
			if debug { print("Replaced Track.") }
		}
		
		// Force Update If Artwork Data Not Found
		
		guard let track = self.track,
			  let artworkData = track.artworkData,
			  !artworkData.isEmpty
		else {
			if debug { print("No artwork data found. Fetching...") }
			return fetchNowPlayingInfo()
		}
	}

	@discardableResult
	final func command(_ command: MRMediaRemoteCommand) -> Bool {
		return MRMediaRemoteSendCommand(command.rawValue, command.dictionary)
	}
}

// Data Types

@Observable
class Track: Equatable {
	private(set) var artist: String
	private(set) var title: String
	private(set) var album: String
	private(set) var duration: TimeInterval
	private(set) var elapsedTime: TimeInterval
	private(set) var artworkId: String?
	private(set) var artworkData: Data?

	init(
		artist: String,
		title: String,
		album: String,
		duration: TimeInterval,
		elapsedTime: TimeInterval,
		artworkId: String? = nil,
		artworkData: Data? = nil
	) {
		self.artist = artist
		self.title = title
		self.album = album
		self.duration = duration
		self.elapsedTime = elapsedTime
		self.artworkId = artworkId
		self.artworkData = artworkData
	}

	func update(using track: Track) -> [String] {
		var updated: [String] = []

		if elapsedTime != track.elapsedTime {
			elapsedTime = track.elapsedTime
			updated.append("elapsedTime")
		}
		if artworkId == nil,
		   let id = track.artworkId {
			artworkId = id
			updated.append("artworkId")
		}
		if artworkData == nil,
		   let data = track.artworkData {
			artworkData = data
			updated.append("artworkData")
		}

		return updated
	}

	static func ==(lhs: Track, rhs: Track) -> Bool {

		// Compare Required Properties

		let isSameTrack = (
			lhs.artist == rhs.artist
			&& lhs.title == rhs.title
			&& lhs.album == rhs.album
			// && lhs.duration == rhs.duration // This is sometimes different for same song.
		)

		// Return False If Tracks Are Different

		guard isSameTrack else { return false }

		// Compare Artwork Data If Available

		guard
			let lhsArtworkData = lhs.artworkData,
			let rhsArtworkData = rhs.artworkData
		else { return true }

		return lhsArtworkData == rhsArtworkData
	}
}
