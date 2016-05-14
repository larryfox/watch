import Foundation

func exec(_ cmd: [String]) -> Int32 {
    let task = NSTask()
    task.launchPath = "/usr/bin/env"
    task.arguments = cmd
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

func cwd() -> String {
    let filemgr = NSFileManager.default()
    return filemgr.currentDirectoryPath
}

func println(_ str: String) {
    fputs("\(str)\n", stdout)
    fflush(stdout)
}
