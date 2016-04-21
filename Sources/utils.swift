import Foundation

func exec(cmd: [String]) -> Int32 {
    let task = NSTask()
    task.launchPath = "/usr/bin/env"
    task.arguments = cmd
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

func cwd() -> String {
    let filemgr = NSFileManager.defaultManager()
    return filemgr.currentDirectoryPath
}
