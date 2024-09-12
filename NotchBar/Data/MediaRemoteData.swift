//
//  MediaRemoteData.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-09.
//

import AppKit

// Load framework
let bundle = CFBundleCreate(kCFAllocatorDefault, NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework"))

// Create Function: Register For Now Playing Notifications

let MRMediaRemoteRegisterForNowPlayingNotificationsPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteRegisterForNowPlayingNotifications" as CFString)
typealias MRMediaRemoteRegisterForNowPlayingNotificationsFunction = @convention(c) (DispatchQueue) -> Void
let MRMediaRemoteRegisterForNowPlayingNotifications = unsafeBitCast(MRMediaRemoteRegisterForNowPlayingNotificationsPointer, to: MRMediaRemoteRegisterForNowPlayingNotificationsFunction.self)

// Create Function: Get Now Playing Information

let MRMediaRemoteGetNowPlayingInfoPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingInfo" as CFString)
typealias MRMediaRemoteGetNowPlayingInfoFunction = @convention(c) (DispatchQueue, @escaping ([String: Any]) -> Void) -> Void
let MRMediaRemoteGetNowPlayingInfo = unsafeBitCast(MRMediaRemoteGetNowPlayingInfoPointer, to: MRMediaRemoteGetNowPlayingInfoFunction.self)

struct MediaRemoteInfo {
	var application: NSRunningApplication?
	var isPlaying: Bool = false
	
	var artist: String?
	var title: String?
	var album: String?
	var duration: TimeInterval?
	var elapsedTime: TimeInterval?
	var artwork: NSImage?
}

final class MediaRemoteData: ObservableObject {
	static let shared = MediaRemoteData()
	
	@Published private(set) var mediaRemoteInfo = MediaRemoteInfo(
		application: nil,
		artist: nil,
		title: nil,
		album: nil,
		duration: nil,
		elapsedTime: nil,
		artwork: nil
	)
	
//	@Published private(set) var artist: String?
//	
//	@Published private(set) var title: String?
//	
//	@Published private(set) var album: String?
//	
//	@Published private(set) var duration: TimeInterval?
//	
//	@Published private(set) var elapsedTime: TimeInterval?
//	
//	@Published private(set) var artwork: NSImage?
//	
//	@Published private(set) var isPlaying: Bool = false
//	@Published private(set) var app: NSRunningApplication?
	
	private init() {
		print("MediaRemote")
		
		// Register For Now Playing Notifications
		
		MRMediaRemoteRegisterForNowPlayingNotifications(DispatchQueue.main);
		
		// Get Media Information
		
		updateNowPlayingInfo()
		
		// Track Notifications
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handleApplicationIsPlayingDidChangeNotification),
			name: Notification.Name("kMRMediaRemoteNowPlayingApplicationIsPlayingDidChangeNotification"),
			object: nil
		)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handleApplicationDidChangeNotification),
			name: Notification.Name("kMRMediaRemoteNowPlayingApplicationDidChangeNotification"),
			object: nil
		)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handleInfoDidChangeNotification),
			name: Notification.Name("kMRMediaRemoteNowPlayingInfoDidChangeNotification"),
			object: nil
		)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handlePlaybackQueueDidChangeNotification),
			name: Notification.Name("kMRMediaRemoteNowPlayingPlaybackQueueDidChangeNotification"),
			object: nil
		)
		
		// kMRMediaRemotePickableRoutesDidChangeNotification
		// kMRMediaRemoteRouteStatusDidChangeNotification
	}
	
	@objc private func handleApplicationIsPlayingDidChangeNotification(_ notification: Notification) {
		print("\n" + "handleApplicationIsPlayingDidChangeNotification")
		
		// Get Notification Information
		
		if let info = notification.userInfo as? [String: Any] {
			updateIsPlaying(info: info)
			updateApp(info: info)
		}
	}
	
	@objc private func handleApplicationDidChangeNotification(_ notification: Notification) {
		print("\n" + "handleApplicationDidChangeNotification")
		
		// Get Notification Information
		
		if let info = notification.userInfo as? [String: Any] {
			updateIsPlaying(info: info)
			updateApp(info: info)
		}
	}
	
	@objc private func handleInfoDidChangeNotification(_ notification: Notification) {
		print("\n" + "handleInfoDidChangeNotification")
		
		// Get Notification Information
		
		if let info = notification.userInfo as? [String: Any] {
			print(info["_MROriginatingNotification"] as! String)
			updateIsPlaying(info: info)
			updateApp(info: info)
			updateNowPlayingInfo()
		}
	}
	
	@objc private func handlePlaybackQueueDidChangeNotification(_ notification: Notification) {
		print("\n" + "handlePlaybackQueueDidChangeNotification")
		
		// Get Notification Information
		
		if let info = notification.userInfo as? [String: Any] {
			print(info["_MROriginatingNotification"] as! String)
			// updateIsPlaying(info: info)
			// updateApp(info: info)
		}
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	private func updateNowPlayingInfo() {
		print("\n" + "updateMediaInfo")
		
		// Get Media Information
		
		MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main, { (information) in
			print("\n" + "MRMediaRemoteGetNowPlayingInfo")
			
			guard !information.isEmpty else {
				print("No information available.")
				return
			}
			
			if let artist = information["kMRMediaRemoteNowPlayingInfoArtist"] as? String {
				self.mediaRemoteInfo.artist = artist
			} else { print("No artist found.") }
			
			if let title = information["kMRMediaRemoteNowPlayingInfoTitle"] as? String {
				self.mediaRemoteInfo.title = title
			} else { print("No title found.") }
			
			if let album = information["kMRMediaRemoteNowPlayingInfoAlbum"] as? String {
				self.mediaRemoteInfo.album = album
			} else { print("No album found.") }
			
			if let duration = information["kMRMediaRemoteNowPlayingInfoDuration"] as? TimeInterval {
				self.mediaRemoteInfo.duration = duration
			} else { print("No duration found.") }
			
			if let elapsedTime = information["kMRMediaRemoteNowPlayingInfoElapsedTime"] as? TimeInterval {
				self.mediaRemoteInfo.elapsedTime = elapsedTime
			} else { print("No elapsedTime found.") }
			
			if let artworkData = information["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data {
				if let artwork = NSImage(data: artworkData) {
					self.mediaRemoteInfo.artwork = artwork
				} else { print("No artwork found.") }
			} else { print("No artworkData found.") }
		})
	}
	
	private func updateIsPlaying(info: [String: Any]) {
		
		// Get Playing Status
		
		if let isPlaying = info["kMRMediaRemoteNowPlayingApplicationIsPlayingUserInfoKey"] as? boolean_t {
			self.mediaRemoteInfo.isPlaying = isPlaying == 1
		} else { print("No isPlaying property.") }
	}
	
	private func updateApp(info: [String: Any]) {
		
		// Get Application Information
		
		if let appInfo = info["kMRNowPlayingClientUserInfoKey"] as? AnyObject {
			if let bundleIdentifier = appInfo.bundleIdentifier as? String {
				let appsFound = NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier)
				if appsFound.count == 1 {
					let appFound = appsFound.first
					if let app = appFound {
						self.mediaRemoteInfo.application = app
					} else { print("No app found.") }
				} else if (appsFound.count == 0) { print("No apps found.") }
				else { print("Multiple apps found:", appsFound) }
			} else { print("No bundleIdentifier property.") }
		} else { print("No appInfo property.") }
	}
}



/*
 startup/quit	_MRMediaRemoteOriginNowPlayingApplicationDidChangeNotification
 
 play/pause		_MRMediaRemotePlayerIsPlayingDidChangeNotification
 autoplay		_kMRNowPlayingPlaybackQueueChangedNotification
 
 track changes	_kMRNowPlayingPlaybackQueueChangedNotification
 */
