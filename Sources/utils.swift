import Foundation

@discardableResult
func exec(_ cmd: [String]) -> Int32 {
    let process = Process()
    process.launchPath = "/usr/bin/env"
    process.arguments = cmd
    process.launch()
    process.waitUntilExit()
    return process.terminationStatus
}

func cwd() -> String {
    let fm = FileManager()
    return fm.currentDirectoryPath
}

func println(_ str: String) {
    fputs("\(str)\n", stdout)
    fflush(stdout)
}
