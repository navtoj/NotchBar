import AppKit

// Load MediaRemote Framework

private let bundle = CFBundleCreate(kCFAllocatorDefault, NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework"))

// Create Function: Register For Now Playing Notifications

private let MRMediaRemoteRegisterForNowPlayingNotificationsPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteRegisterForNowPlayingNotifications" as CFString)
internal typealias MRMediaRemoteRegisterForNowPlayingNotificationsFunction = @convention(c) (DispatchQueue) -> Void
internal let MRMediaRemoteRegisterForNowPlayingNotifications = unsafeBitCast(MRMediaRemoteRegisterForNowPlayingNotificationsPointer, to: MRMediaRemoteRegisterForNowPlayingNotificationsFunction.self)

// Create Function: Unregister For Now Playing Notifications

private let MRMediaRemoteUnregisterForNowPlayingNotificationsPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteUnregisterForNowPlayingNotifications" as CFString)
internal typealias MRMediaRemoteUnregisterForNowPlayingNotificationsFunction = @convention(c) () -> Void
internal let MRMediaRemoteUnregisterForNowPlayingNotifications = unsafeBitCast(MRMediaRemoteUnregisterForNowPlayingNotificationsPointer, to: MRMediaRemoteUnregisterForNowPlayingNotificationsFunction.self)

// Create Function: Get Application Information

private let MRMediaRemoteGetNowPlayingApplicationPIDPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingApplicationPID" as CFString)
internal typealias MRMediaRemoteGetNowPlayingApplicationPIDFunction = @convention(c) (DispatchQueue, @escaping (Int) -> Void) -> Void
internal let MRMediaRemoteGetNowPlayingApplicationPID = unsafeBitCast(MRMediaRemoteGetNowPlayingApplicationPIDPointer, to: MRMediaRemoteGetNowPlayingApplicationPIDFunction.self)

// Create Function: Get Is Playing Information

private let MRMediaRemoteGetNowPlayingApplicationIsPlayingPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingApplicationIsPlaying" as CFString)
internal typealias MRMediaRemoteGetNowPlayingApplicationIsPlayingFunction = @convention(c) (DispatchQueue, @escaping (Bool) -> Void) -> Void
internal let MRMediaRemoteGetNowPlayingApplicationIsPlaying = unsafeBitCast(MRMediaRemoteGetNowPlayingApplicationIsPlayingPointer, to: MRMediaRemoteGetNowPlayingApplicationIsPlayingFunction.self)

// Create Function: Get Now Playing Information

private let MRMediaRemoteGetNowPlayingInfoPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingInfo" as CFString)
internal typealias MRMediaRemoteGetNowPlayingInfoFunction = @convention(c) (DispatchQueue, @escaping ([String: Any]) -> Void) -> Void
internal let MRMediaRemoteGetNowPlayingInfo = unsafeBitCast(MRMediaRemoteGetNowPlayingInfoPointer, to: MRMediaRemoteGetNowPlayingInfoFunction.self)

// Create Function: Send Command

private let MRMediaRemoteSendCommandPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteSendCommand" as CFString)
internal typealias MRMediaRemoteSendCommandFunction = @convention(c) (Int, [String: Any]?) -> Bool
internal let MRMediaRemoteSendCommand = unsafeBitCast(MRMediaRemoteSendCommandPointer, to: MRMediaRemoteSendCommandFunction.self)

enum MRMediaRemoteCommand: Int {
	/*
	 * Use nil for userInfo.
	 */
	case Play
	case Pause
	case TogglePlayPause
	case Stop
	case NextTrack
	case PreviousTrack
	case AdvanceShuffleMode
	case AdvanceRepeatMode
	case BeginFastForward
	case EndFastForward
	case BeginRewind
	case EndRewind
	case Rewind15Seconds
	case FastForward15Seconds
	case Rewind30Seconds
	case FastForward30Seconds
	case ToggleRecord
	case SkipForward
	case SkipBackward
	case ChangePlaybackRate

	/*
	 * Use a NSDictionary for userInfo, which contains three keys:
	 * kMRMediaRemoteOptionTrackID
	 * kMRMediaRemoteOptionStationID
	 * kMRMediaRemoteOptionStationHash
	 */
	case RateTrack
	case LikeTrack
	case DislikeTrack
	case BookmarkTrack

	/*
	 * Use nil for userInfo.
	 */
	case SeekToPlaybackPosition
	case ChangeRepeatMode
	case ChangeShuffleMode
	case EnableLanguageOption
	case DisableLanguageOption

	var dictionary: [String: Any]? {
		switch self {
			case .RateTrack, .LikeTrack, .DislikeTrack, .BookmarkTrack:
				[
					"kMRMediaRemoteOptionTrackID": "",
					"kMRMediaRemoteOptionStationID": "",
					"kMRMediaRemoteOptionStationHash": ""
				]
			case .Rewind15Seconds:
				[
					"status": "test"
				]
			default:
				nil
		}
	}
}
