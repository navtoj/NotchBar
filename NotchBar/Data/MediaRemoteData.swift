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

class Track: Equatable {
	private(set) var artist: String
	private(set) var title: String
	private(set) var album: String
	private(set) var duration: TimeInterval
	private(set) var elapsedTime: TimeInterval
	private(set) var artworkId: String?
	private(set) var artwork: NSImage?
	
	init(artist: String, title: String, album: String, duration: TimeInterval, elapsedTime: TimeInterval, artworkId: String?, artwork: NSImage?) {
		self.artist = artist
		self.title = title
		self.album = album
		self.duration = duration
		self.elapsedTime = elapsedTime
		self.artworkId = artworkId
		self.artwork = artwork
	}
	
	func update(using track: Track) {
		elapsedTime = track.elapsedTime
		if artworkId == nil && track.artworkId != nil { artworkId = track.artworkId }
		if artwork   == nil && track.artwork   != nil { artwork   = track.artwork }
	}
	func replace(with track: Track) {
		artist = track.artist
		title = track.title
		album = track.album
		duration = track.duration
		elapsedTime = track.elapsedTime
		artworkId = track.artworkId
		artwork = track.artwork
	}
	
	static func == (lhs: Track, rhs: Track) -> Bool {
		
		// Compare All Properties Except Elapsed Time, Artwork, and Artwork ID
		
		let isSameTrack = (
			lhs.artist == rhs.artist
			&& lhs.title == rhs.title
			&& lhs.album == rhs.album
			&& lhs.duration == rhs.duration
		)
		
		// If Same Track, Compare Artwork ID If Available
		
		if isSameTrack && lhs.artworkId != nil && rhs.artworkId != nil {
			return lhs.artworkId == rhs.artworkId
		}
		
		// Otherwise, Return Result
		
		return isSameTrack
	}
}


final class MediaRemoteData: ObservableObject {
#if DEBUG
	private let debug = true
#else
	private let debug = false
#endif
	static let shared = MediaRemoteData()
	
//	@Published private(set) var mediaRemoteInfo = MediaRemoteInfo(isPlaying: false)
	@Published private(set) var application: NSRunningApplication?
	@Published private(set) var isPlaying: Bool = false
	@Published private(set) var track: Track?
	
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
	
	deinit {
		NotificationCenter.default.removeObserver(self)
		MRMediaRemoteUnregisterForNowPlayingNotifications()
	}
	
	private func fetchApplication() {
		if debug { print("\n" + "fetchApplication") }
		
		MRMediaRemoteGetNowPlayingApplicationPID(DispatchQueue.main, { (pid) in
			let app = NSRunningApplication(processIdentifier: pid_t(pid))
			
			if self.debug { print("fetchApplication :", app?.bundleIdentifier ?? (pid == 0 ? "nil" : pid)) }
			
//			self.mediaRemoteInfo.setApplication(to: app)
			self.application = app
		})
	}
	
	private func fetchIsPlaying() {
		if debug { print("\n" + "fetchIsPlaying") }
		
		MRMediaRemoteGetNowPlayingApplicationIsPlaying(DispatchQueue.main, { (isPlaying) in
			if self.debug { print("fetchIsPlaying :", isPlaying) }
			
//			self.mediaRemoteInfo.setIsPlaying(to: isPlaying)
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
//				self.mediaRemoteInfo.clearTrack()
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
//						mediaRemoteInfo.setApplication(to: app)
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
//			mediaRemoteInfo.setIsPlaying(to: isPlaying == 1)
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
		
		// Store Track Artwork
		
		var artwork: NSImage? = artwork
		
		// If No Artwork, Find Existing Artwork
		
		if artwork == nil {
			if let artworkId = artworkId,
			   let track = track,
			   let currentArtworkId = track.artworkId {
				if currentArtworkId == artworkId {
					if let currentArtwork = track.artwork {
						if debug { print("Using existing artwork.") }
						artwork = currentArtwork
					}
				}
			}
		}
		
		// Create Track
		
		let track = Track(
			artist: artist,
			title: title,
			album: album,
			duration: duration,
			elapsedTime: elapsedTime,
			artworkId: artworkId,
			artwork: artwork
		)
		
		// Update Track
		
		if let current = self.track {
			if current == track {
				if debug { print("Updating track...") }
				current.update(using: track)
			} else {
				if debug { print("Replacing track...") }
				current.replace(with: track)
			}
		} else {
			if debug { print("Setting track...") }
//			mediaRemoteInfo.setTrack(to: track)
			self.track = track
		}
		
		// Force Update If Artwork Not Found
		
		if track.artwork == nil {
			if debug { print("No artwork found. Fetching...") }
			fetchNowPlayingInfo()
		}
	}
}

/*
// Use Existing Artwork If Available

if track.artwork == nil {
	if let nowPlaying = mediaRemoteInfo.track {
		if let artwork = nowPlaying.artwork {
			if (
				(track == nowPlaying)
				||
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
				track.setArtwork(to: artwork)
			}
		}
	}
}
*/

// startup/quit		_MRMediaRemoteOriginNowPlayingApplicationDidChangeNotification
// play/pause		_MRMediaRemotePlayerIsPlayingDidChangeNotification
// track changes	_kMRNowPlayingPlaybackQueueChangedNotification
// unknown trigger	_MRPlayerPlaybackQueueContentItemArtworkChangedNotification

/*
let notifications = [
	"MRMediaRemoteNowPlayingApplicationClientStateDidChange",
	"kMRMediaRemoteNowPlayingPlaybackQueueDidChangeNotification",
	"kMRPlaybackQueueContentItemsChangedNotification",
	"kMRMediaRemotePickableRoutesDidChangeNotification",
	"kMRMediaRemoteRouteStatusDidChangeNotification"
]
for notification in notifications {
	NotificationCenter.default.addObserver(
		self,
		selector: #selector(handleNotification),
		name: Notification.Name(notification),
		object: nil
	)
}
*/

/*
struct MediaRemoteInfo {
	private(set) var application: NSRunningApplication?
	private(set) var isPlaying: Bool
	private(set) var track: NowPlaying?
	
	mutating func setApplication(to application: NSRunningApplication?) {
		self.application = application
	}
	mutating func setIsPlaying(to isPlaying: Bool) {
		self.isPlaying = isPlaying
	}
	mutating func setTrack(to track: NowPlaying) {
		self.track = track
	}
	mutating func clearTrack() {
		self.track = nil
	}
}
*/

/*
struct NowPlaying: Equatable {
	private(set) var artist: String
	private(set) var title: String
	private(set) var album: String
	private(set) var duration: TimeInterval
	private(set) var elapsedTime: TimeInterval
	private(set) var artworkId: String?
	private(set) var artwork: NSImage?
	
//	mutating func setElapsedTime(to elapsedTime: TimeInterval) {
//		self.elapsedTime = elapsedTime
//	}
//	mutating func setArtwork(to artwork: NSImage) {
//		self.artwork = artwork
//	}
	
	mutating func update(using track: NowPlaying) {
		self.elapsedTime = track.elapsedTime
		if self.artworkId == nil && track.artworkId != nil { self.artworkId = track.artworkId }
		if self.artwork   == nil && track.artwork   != nil { self.artwork   = track.artwork }
	}
	mutating func replace(with track: NowPlaying) {
		self.artist = track.artist
		self.title = track.title
		self.album = track.album
		self.duration = track.duration
		self.elapsedTime = track.elapsedTime
		self.artworkId = track.artworkId
		self.artwork = track.artwork
	}
	
	private static func == (lhs: NowPlaying, rhs: NowPlaying) -> Bool {
		
		// Compare All Properties Except Elapsed Time, Artwork, and Artwork ID
		
		let isSameTrack = (
			lhs.artist == rhs.artist
			&& lhs.title == rhs.title
			&& lhs.album == rhs.album
			&& lhs.duration == rhs.duration
		)
		
		// If Same Track, Compare Artwork ID If Available
		
		if isSameTrack && lhs.artworkId != nil && rhs.artworkId != nil {
			return lhs.artworkId == rhs.artworkId
		}
		
		// Otherwise, Return Result
		
		return isSameTrack
	}
}
*/
