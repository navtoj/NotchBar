//
//  MediaRemoteData.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-09.
//

import AppKit

// Load MediaRemote Framework

private let bundle = CFBundleCreate(kCFAllocatorDefault, NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework"))

// Create Function: Register For Now Playing Notifications

private let MRMediaRemoteRegisterForNowPlayingNotificationsPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteRegisterForNowPlayingNotifications" as CFString)
private typealias MRMediaRemoteRegisterForNowPlayingNotificationsFunction = @convention(c) (DispatchQueue) -> Void
private let MRMediaRemoteRegisterForNowPlayingNotifications = unsafeBitCast(MRMediaRemoteRegisterForNowPlayingNotificationsPointer, to: MRMediaRemoteRegisterForNowPlayingNotificationsFunction.self)

// Create Function: Unregister For Now Playing Notifications

private let MRMediaRemoteUnregisterForNowPlayingNotificationsPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteUnregisterForNowPlayingNotifications" as CFString)
private typealias MRMediaRemoteUnregisterForNowPlayingNotificationsFunction = @convention(c) () -> Void
private let MRMediaRemoteUnregisterForNowPlayingNotifications = unsafeBitCast(MRMediaRemoteUnregisterForNowPlayingNotificationsPointer, to: MRMediaRemoteUnregisterForNowPlayingNotificationsFunction.self)

// Create Function: Get Application Information

private let MRMediaRemoteGetNowPlayingApplicationPIDPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingApplicationPID" as CFString)
private typealias MRMediaRemoteGetNowPlayingApplicationPIDFunction = @convention(c) (DispatchQueue, @escaping (Int) -> Void) -> Void
private let MRMediaRemoteGetNowPlayingApplicationPID = unsafeBitCast(MRMediaRemoteGetNowPlayingApplicationPIDPointer, to: MRMediaRemoteGetNowPlayingApplicationPIDFunction.self)

// Create Function: Get Is Playing Information

private let MRMediaRemoteGetNowPlayingApplicationIsPlayingPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingApplicationIsPlaying" as CFString)
private typealias MRMediaRemoteGetNowPlayingApplicationIsPlayingFunction = @convention(c) (DispatchQueue, @escaping (Bool) -> Void) -> Void
private let MRMediaRemoteGetNowPlayingApplicationIsPlaying = unsafeBitCast(MRMediaRemoteGetNowPlayingApplicationIsPlayingPointer, to: MRMediaRemoteGetNowPlayingApplicationIsPlayingFunction.self)

// Create Function: Get Now Playing Information

private let MRMediaRemoteGetNowPlayingInfoPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingInfo" as CFString)
private typealias MRMediaRemoteGetNowPlayingInfoFunction = @convention(c) (DispatchQueue, @escaping ([String: Any]) -> Void) -> Void
private let MRMediaRemoteGetNowPlayingInfo = unsafeBitCast(MRMediaRemoteGetNowPlayingInfoPointer, to: MRMediaRemoteGetNowPlayingInfoFunction.self)

// Data Types

struct NowPlaying {
	private(set) var artist: String
	private(set) var title: String
	private(set) var album: String
	private(set) var duration: TimeInterval
	private(set) var elapsedTime: TimeInterval
	private(set) var artworkId: String?
	private(set) var artwork: NSImage?
	
	mutating func setArtwork(_ artwork: NSImage) {
		self.artwork = artwork
	}
}

struct MediaRemoteInfo {
	private(set) var application: NSRunningApplication?
	private(set) var isPlaying: Bool
	private(set) var nowPlaying: NowPlaying?
	
	mutating func setApplication(_ application: NSRunningApplication?) {
		self.application = application
	}
	mutating func setIsPlaying(_ isPlaying: Bool) {
		self.isPlaying = isPlaying
	}
	mutating func setNowPlaying(_ nowPlaying: NowPlaying?) {
		self.nowPlaying = nowPlaying
	}
}

final class MediaRemoteData: ObservableObject {
#if DEBUG
	private let debug = true
#else
	private let debug = false
#endif
	static let shared = MediaRemoteData()
	
	@Published private(set) var mediaRemoteInfo = MediaRemoteInfo(isPlaying: false)
	
	private init() {
		if debug { print("MediaRemoteData") }
		
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
		
//		let notifications = [
//			"MRMediaRemoteNowPlayingApplicationClientStateDidChange",
//			"kMRMediaRemoteNowPlayingPlaybackQueueDidChangeNotification",
//			"kMRPlaybackQueueContentItemsChangedNotification",
//			"kMRMediaRemotePickableRoutesDidChangeNotification",
//			"kMRMediaRemoteRouteStatusDidChangeNotification"
//		]
//		for notification in notifications {
//			NotificationCenter.default.addObserver(
//				self,
//				selector: #selector(handleNotification),
//				name: Notification.Name(notification),
//				object: nil
//			)
//		}
	}
	
	@objc private func handleApplicationDidChangeNotification(_ notification: Notification) {
		if debug { print("\n// " + "handleApplicationDidChangeNotification") }
		
		// Get Notification Information
		
		if let info = notification.userInfo as? [String: Any] {
			let application = getApplication(from: info)
			if debug { print(application) }
		}
	}
	
	@objc private func handleApplicationIsPlayingDidChangeNotification(_ notification: Notification) {
		if debug { print("\n// " + "handleApplicationIsPlayingDidChangeNotification") }
		
		// Get Notification Information
		
		if let info = notification.userInfo as? [String: Any] {
			let isPlaying = getIsPlaying(from: info)
			if debug { print(isPlaying) }
		}
	}
	
	@objc private func handlePlaybackQueueChangedNotification(_ notification: Notification) {
		if debug { print("\n// " + "handlePlaybackQueueChangedNotification") }
		
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
		if debug { print("\n// " + "handleInfoDidChangeNotification") }
		
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
	
//	@objc private func handleNotification(_ notification: Notification) {
//		if debug { print("\n// " + "handleNotification", notification.name.rawValue) }
//
//		// Get Notification Information
//
//		if let info = notification.userInfo as? [String: Any] {
//			if let origin = info["_MROriginatingNotification"] as? String {
//					if debug { print(origin) }
//					if debug { print(info) }
//			} else { if debug { print("No origin found.") } }
//		}
//	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
		MRMediaRemoteUnregisterForNowPlayingNotifications()
	}
	
	private func fetchApplication() {
		if debug { print("\n" + "fetchApplication") }
		
		MRMediaRemoteGetNowPlayingApplicationPID(DispatchQueue.main, { (pid) in
			let app = NSRunningApplication(processIdentifier: pid_t(pid))
			
			if self.debug { print("fetchApplication :", app?.bundleIdentifier ?? (pid == 0 ? "nil" : pid)) }
			
			self.mediaRemoteInfo.setApplication(app)
		})
	}
	
	private func fetchIsPlaying() {
		if debug { print("\n" + "fetchIsPlaying") }
		
		MRMediaRemoteGetNowPlayingApplicationIsPlaying(DispatchQueue.main, { (isPlayingNow) in
			if self.debug { print("fetchIsPlaying :", isPlayingNow) }
			
			self.mediaRemoteInfo.setIsPlaying(isPlayingNow)
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
				var artwork: NSImage? = nil
				if
					let artworkIdentifier = information["kMRMediaRemoteNowPlayingInfoArtworkIdentifier"] as? String,
					let artworkData = information["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data
				{
					artworkId = artworkIdentifier
					artwork = NSImage(data: artworkData)
				}
				
				self.updateNowPlayingInfo(
					artist: artist,
					title: title,
					album: album,
					duration: duration,
					elapsedTime: elapsedTime,
					artworkId: artworkId,
					artwork: artwork
				)
			} else {
				self.mediaRemoteInfo.setNowPlaying(nil)
				if self.debug { print("fetchNowPlayingInfo :", self.mediaRemoteInfo.nowPlaying as Any) }
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
						mediaRemoteInfo.setApplication(app)
						
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
			mediaRemoteInfo.setIsPlaying(isPlaying == 1)
			
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
						updateNowPlayingInfo(
							artist: artist,
							title: title,
							album: album,
							duration: duration,
							elapsedTime: elapsedTime,
							artworkId: artworkId,
							artwork: nil
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
	
	private func updateNowPlayingInfo(artist: String, title: String, album: String, duration: TimeInterval, elapsedTime: TimeInterval, artworkId: String?, artwork: NSImage?) {
		if debug {
			print("updateNowPlayingInfo")
			print("> artworkId :", artworkId != nil ? artworkId! : "nil")
		}
		
		// Create Track
		
		var track = NowPlaying(
			artist: artist,
			title: title,
			album: album,
			duration: duration,
			elapsedTime: elapsedTime,
			artworkId: artworkId,
			artwork: artwork
		)
		
		// Use Existing Artwork If Available
		
		if track.artwork == nil {
			if let nowPlaying = mediaRemoteInfo.nowPlaying {
				if let artwork = nowPlaying.artwork {
					if (
						(track.artworkId != nil
						 && nowPlaying.artworkId != nil
						 && track.artworkId == nowPlaying.artworkId)
						||
						(track.artist == nowPlaying.artist
						 && track.title == nowPlaying.title
						 && track.album == nowPlaying.album
						 && track.duration == nowPlaying.duration)
					) {
						if debug { print("Using existing artwork.") }
						track.setArtwork(artwork)
					}
				}
			}
		}
		
		// Update Track
		
		mediaRemoteInfo.setNowPlaying(track)
		
		// Force Update If Artwork Not Found
		
		if track.artwork == nil {
			if debug { print("No artwork found. Fetching...") }
			fetchNowPlayingInfo()
		}
	}
}

// startup/quit		_MRMediaRemoteOriginNowPlayingApplicationDidChangeNotification
// play/pause		_MRMediaRemotePlayerIsPlayingDidChangeNotification
// track changes	_kMRNowPlayingPlaybackQueueChangedNotification
// unknown trigger	_MRPlayerPlaybackQueueContentItemArtworkChangedNotification
