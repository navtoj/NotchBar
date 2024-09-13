//
//  MediaRemoteData.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-09.
//

import AppKit

// Load MediaRemote Framework

let bundle = CFBundleCreate(kCFAllocatorDefault, NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework"))

// Create Function: Register For Now Playing Notifications

let MRMediaRemoteRegisterForNowPlayingNotificationsPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteRegisterForNowPlayingNotifications" as CFString)
typealias MRMediaRemoteRegisterForNowPlayingNotificationsFunction = @convention(c) (DispatchQueue) -> Void
let MRMediaRemoteRegisterForNowPlayingNotifications = unsafeBitCast(MRMediaRemoteRegisterForNowPlayingNotificationsPointer, to: MRMediaRemoteRegisterForNowPlayingNotificationsFunction.self)

// Create Function: Unregister For Now Playing Notifications

let MRMediaRemoteUnregisterForNowPlayingNotificationsPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteUnregisterForNowPlayingNotifications" as CFString)
typealias MRMediaRemoteUnregisterForNowPlayingNotificationsFunction = @convention(c) () -> Void
let MRMediaRemoteUnregisterForNowPlayingNotifications = unsafeBitCast(MRMediaRemoteUnregisterForNowPlayingNotificationsPointer, to: MRMediaRemoteUnregisterForNowPlayingNotificationsFunction.self)

// Create Function: Get Application Information

let MRMediaRemoteGetNowPlayingApplicationPIDPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingApplicationPID" as CFString)
typealias MRMediaRemoteGetNowPlayingApplicationPIDFunction = @convention(c) (DispatchQueue, @escaping (Int) -> Void) -> Void
let MRMediaRemoteGetNowPlayingApplicationPID = unsafeBitCast(MRMediaRemoteGetNowPlayingApplicationPIDPointer, to: MRMediaRemoteGetNowPlayingApplicationPIDFunction.self)

// Create Function: Get Is Playing Information

let MRMediaRemoteGetNowPlayingApplicationIsPlayingPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingApplicationIsPlaying" as CFString)
typealias MRMediaRemoteGetNowPlayingApplicationIsPlayingFunction = @convention(c) (DispatchQueue, @escaping (Bool) -> Void) -> Void
let MRMediaRemoteGetNowPlayingApplicationIsPlaying = unsafeBitCast(MRMediaRemoteGetNowPlayingApplicationIsPlayingPointer, to: MRMediaRemoteGetNowPlayingApplicationIsPlayingFunction.self)

// Create Function: Get Now Playing Information

let MRMediaRemoteGetNowPlayingInfoPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingInfo" as CFString)
typealias MRMediaRemoteGetNowPlayingInfoFunction = @convention(c) (DispatchQueue, @escaping ([String: Any]) -> Void) -> Void
let MRMediaRemoteGetNowPlayingInfo = unsafeBitCast(MRMediaRemoteGetNowPlayingInfoPointer, to: MRMediaRemoteGetNowPlayingInfoFunction.self)

// Data Type

struct NowPlaying/*: Equatable*/ {
	var artist: String
	var title: String
	var album: String
	var duration: TimeInterval
	var elapsedTime: TimeInterval
	var artwork: NSImage?
	
//	static func ==(lhs: NowPlaying, rhs: NowPlaying) -> Bool {
//		return lhs.artist == rhs.artist
//		&& lhs.title == rhs.title
//		&& lhs.album == rhs.album
//		&& lhs.duration == rhs.duration
//		&& lhs.elapsedTime == rhs.elapsedTime
//	}
}

struct MediaRemoteInfo {
	var application: NSRunningApplication?
	
	var isPlaying: Bool

	var nowPlaying: NowPlaying?
}

final class MediaRemoteData: ObservableObject {
	static let shared = MediaRemoteData()
	
	@Published private(set) var mediaRemoteInfo = MediaRemoteInfo(isPlaying: false)
	
	private init() {
		print("MediaRemoteData")
		
		// Register For Now Playing Notifications
		
		MRMediaRemoteRegisterForNowPlayingNotifications(DispatchQueue.main);
		
		// Get Current Information
		
		updateApplication()
		updateIsPlaying()
		updateNowPlayingInfo()
		
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
		print("\n// " + "handleApplicationDidChangeNotification")
		
		// Get Notification Information
		
		if let info = notification.userInfo as? [String: Any] {
			print(getApplication(from: info, debug: true))
			print(getIsPlaying(from: info, debug: true))
		}
	}
	
	@objc private func handleApplicationIsPlayingDidChangeNotification(_ notification: Notification) {
		print("\n// " + "handleApplicationIsPlayingDidChangeNotification")
		
		// Get Notification Information
		
		if let info = notification.userInfo as? [String: Any] {
			print(getIsPlaying(from: info, debug: true))
			print(getApplication(from: info, debug: true))
		}
	}
	
	@objc private func handlePlaybackQueueChangedNotification(_ notification: Notification) {
		print("\n// " + "handlePlaybackQueueChangedNotification")
		
		// Get Notification Information
		
		if let info = notification.userInfo as? [String: Any] {
			if let origin = info["_MROriginatingNotification"] as? String {
				
				// make sure notification does not overlap with other handlers
				if ![
					"_MRMediaRemoteOriginNowPlayingApplicationDidChangeNotification",
				].contains(origin) {
					
					// make sure notification is relevant
					guard origin == "_kMRNowPlayingPlaybackQueueChangedNotification"
					else {
						print(origin)
						print(info)
						return
					}
					
					// try to get now playing info from notification but force update if not found
					if !getNowPlaying(from: info, debug: true) { updateNowPlayingInfo(debug: true) }
				}
			}
		}
	}
	
	@objc private func handleInfoDidChangeNotification(_ notification: Notification) {
		print("\n// " + "handleInfoDidChangeNotification")
		
		// Get Notification Information
		
		if let info = notification.userInfo as? [String: Any] {
			if let origin = info["_MROriginatingNotification"] as? String {
				if ![
					"_MRMediaRemoteOriginNowPlayingApplicationDidChangeNotification",
					"_MRMediaRemotePlayerIsPlayingDidChangeNotification",
					"_kMRNowPlayingPlaybackQueueChangedNotification"
				].contains(origin) {
					if origin == "_MRPlayerPlaybackQueueContentItemArtworkChangedNotification" {
						updateNowPlayingInfo(debug: true)
					} else {
						print(origin)
						print(info)
					}
				}
			} else { print("No origin found.") }
		}
	}
	
//	@objc private func handleNotification(_ notification: Notification) {
//		print("\n// " + "handleNotification", notification.name.rawValue)
//
//		// Get Notification Information
//
//		if let info = notification.userInfo as? [String: Any] {
//			if let origin = info["_MROriginatingNotification"] as? String {
//					print(origin)
//					print(info)
//			} else { print("No origin found.") }
//		}
//	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
		MRMediaRemoteUnregisterForNowPlayingNotifications()
	}
	
	private func updateApplication(debug: Bool = false) {
		if debug {
			print("\n" + "updateApplication")
		}
		
		MRMediaRemoteGetNowPlayingApplicationPID(DispatchQueue.main, { (pid) in
			if debug {
				print("updateApplication : ", pid == 0 ? "nil" : pid)
			}
			
			self.mediaRemoteInfo.application = NSRunningApplication(processIdentifier: pid_t(pid))
		})
	}
	
	private func updateIsPlaying(debug: Bool = false) {
		if debug {
			print("\n" + "updateIsPlaying")
		}
		
		MRMediaRemoteGetNowPlayingApplicationIsPlaying(DispatchQueue.main, { (isPlayingNow) in
			if debug {
				print("updateIsPlaying : ", isPlayingNow)
			}
			
			self.mediaRemoteInfo.isPlaying = isPlayingNow
		})
	}
	
	private func updateNowPlayingInfo(debug: Bool = false) {
		if debug {
			print("\n" + "updateNowPlayingInfo")
		}
		
		MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main, { (information) in
			if debug {
				print("updateNowPlayingInfo : ", information.count, "items")
			}
			
			guard !information.isEmpty else { return }
			
			if
				let artist = information["kMRMediaRemoteNowPlayingInfoArtist"] as? String,
				let title = information["kMRMediaRemoteNowPlayingInfoTitle"] as? String,
				let album = information["kMRMediaRemoteNowPlayingInfoAlbum"] as? String,
				let duration = information["kMRMediaRemoteNowPlayingInfoDuration"] as? TimeInterval,
				let elapsedTime = information["kMRMediaRemoteNowPlayingInfoElapsedTime"] as? TimeInterval
			{
				// get artwork separately to handle optional value
				let artworkData = information["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data
				if artworkData == nil && debug { print("No artworkData property.") }
				let artwork = artworkData != nil ? NSImage(data: artworkData!) : nil
				if artworkData != nil && artwork == nil && debug { print("No artwork found.") }
				
				var nowPlaying = NowPlaying(
					artist: artist,
					title: title,
					album: album,
					duration: duration,
					elapsedTime: elapsedTime,
					artwork: artwork
				)
				
				// if artwork not found, use existing artwork if same track
				if nowPlaying.artwork == nil {
					if let existingNowPlaying = self.mediaRemoteInfo.nowPlaying {
						if let existingArtwork = existingNowPlaying.artwork {
							if (
								existingNowPlaying.album == nowPlaying.album
								&& existingNowPlaying.artist == nowPlaying.artist
								&& existingNowPlaying.title == nowPlaying.title
								&& existingNowPlaying.duration == nowPlaying.duration
							) {
								nowPlaying.artwork = existingArtwork
								if debug { print("Existing artwork found.") }
							} else { print("Existing track does not match.") }
						} else { print("No existing artwork.") }
					}
				}
				
				self.mediaRemoteInfo.nowPlaying = nowPlaying
				
			} else {
				if debug { print("Missing information.") }
				self.mediaRemoteInfo.nowPlaying = nil
			}
		})
	}
	
	private func getApplication(from info: [String: Any], debug: Bool = false) -> Bool {
		if debug {
			print("\n" + "getApplication")
		}
		
		if let appInfo = info["kMRNowPlayingClientUserInfoKey"] as? AnyObject {
			if let bundleIdentifier = appInfo.bundleIdentifier as? String {
				let appsFound = NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier)
				if appsFound.count == 1 {
					let appFound = appsFound.first
					if let app = appFound {
						mediaRemoteInfo.application = app
						
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
	
	private func getIsPlaying(from info: [String: Any], debug: Bool = false) -> Bool {
		if debug {
			print("\n" + "getIsPlaying")
		}
		
		if let isPlaying = info["kMRMediaRemoteNowPlayingApplicationIsPlayingUserInfoKey"] as? boolean_t {
			mediaRemoteInfo.isPlaying = isPlaying == 1
			
			// if isPlaying was found
			return true
		} else { if debug { print("No isPlaying property.") } }
		
		// if isPlaying was not found
		return false
	}
	
	private func getNowPlaying(from info: [String: Any], debug: Bool = false) -> Bool {
		if debug {
			print("\n" + "getNowPlaying")
		}
		
		if let updatedContentItems = info["kMRMediaRemoteUpdatedContentItemsUserInfoKey"] as? [AnyObject] {
			if let updatedContent = updatedContentItems.first {
				if let metadata = updatedContent.value(forKey: "metadata") as? AnyObject {
					if
						let artist = metadata.value(forKey: "trackArtistName") as? String,
						let title = metadata.value(forKey: "title") as? String,
						let album = metadata.value(forKey: "albumName") as? String,
						let duration = metadata.value(forKey: "duration") as? TimeInterval,
						let elapsedTime = metadata.value(forKey: "elapsedTime") as? TimeInterval
					{
						var nowPlaying = NowPlaying(
							artist: artist,
							title: title,
							album: album,
							duration: duration,
							elapsedTime: elapsedTime
						)
						
						// if artwork not found, use existing artwork if same track
						if nowPlaying.artwork == nil {
							if let existingNowPlaying = self.mediaRemoteInfo.nowPlaying {
								if let existingArtwork = existingNowPlaying.artwork {
									if (
										existingNowPlaying.album == nowPlaying.album
										&& existingNowPlaying.artist == nowPlaying.artist
										&& existingNowPlaying.title == nowPlaying.title
										&& existingNowPlaying.duration == nowPlaying.duration
									) {
										nowPlaying.artwork = existingArtwork
										if debug { print("Existing artwork found.") }
									} else { print("Existing track does not match.") }
								} else { print("No existing artwork.") }
							} else { print("No existing nowPlaying.") }
						} else { print("New Artwork found.") }
						
						self.mediaRemoteInfo.nowPlaying = nowPlaying
						
						// if nowPlaying was found
						return true
					} else { if debug { print("Missing metadata.") } }
				} else { if debug { print("No metadata property.") } }
			} else { if debug { print("No updatedContent property.", updatedContentItems) } }
		} else { if debug { print("No updatedContentItems property.") } }
		
		// if nowPlaying was not found
		return false
	}
}

// startup/quit		_MRMediaRemoteOriginNowPlayingApplicationDidChangeNotification
// play/pause		_MRMediaRemotePlayerIsPlayingDidChangeNotification
// track changes	_kMRNowPlayingPlaybackQueueChangedNotification
// unknown trigger	_MRPlayerPlaybackQueueContentItemArtworkChangedNotification
