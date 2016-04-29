import Foundation

struct FSEventFlag: OptionSet {
    let rawValue: UInt32

    static let None             = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagNone))
    static let MustScanSubDirs  = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagMustScanSubDirs))
    static let UserDropped      = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagUserDropped))
    static let KernelDropped    = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagKernelDropped))
    static let EventIdsWrapped  = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagEventIdsWrapped))
    static let HistoryDone      = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagHistoryDone))
    static let RootChanged      = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagRootChanged))
    static let Mount            = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagMount))
    static let Unmount          = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagUnmount))
    static let Created          = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagItemCreated))
    static let Removed          = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagItemRemoved))
    static let InodeMetaMod     = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagItemInodeMetaMod))
    static let Renamed          = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagItemRenamed))
    static let Modified         = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagItemModified))
    static let FinderInfoMod    = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagItemFinderInfoMod))
    static let ChangeOwner      = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagItemChangeOwner))
    static let XattrMod         = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagItemXattrMod))
    static let IsFile           = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagItemIsFile))
    static let IsDir            = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagItemIsDir))
    static let IsSymlink        = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagItemIsSymlink))
    static let OwnEvent         = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagOwnEvent))
    static let IsHardlink       = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagItemIsHardlink))
    static let IsLastHardlink   = FSEventFlag(rawValue: UInt32(kFSEventStreamEventFlagItemIsLastHardlink))
}

struct FSWatchFlag: OptionSet {
    let rawValue: UInt32

    static let None        = FSWatchFlag(rawValue: UInt32(kFSEventStreamCreateFlagNone))
    static let UseCFTypes  = FSWatchFlag(rawValue: UInt32(kFSEventStreamCreateFlagUseCFTypes))
    static let NoDefer     = FSWatchFlag(rawValue: UInt32(kFSEventStreamCreateFlagNoDefer))
    static let WatchRoot   = FSWatchFlag(rawValue: UInt32(kFSEventStreamCreateFlagWatchRoot))
    static let IgnoreSelf  = FSWatchFlag(rawValue: UInt32(kFSEventStreamCreateFlagIgnoreSelf))
    static let FileEvents  = FSWatchFlag(rawValue: UInt32(kFSEventStreamCreateFlagFileEvents))
    static let MarkSelf    = FSWatchFlag(rawValue: UInt32(kFSEventStreamCreateFlagMarkSelf))
}
