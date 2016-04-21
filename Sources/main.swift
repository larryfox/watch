import Foundation

guard Process.arguments.count >= 3 else {
    print("usage: watch <path> <cmd>...")
    exit(1)
}

let path: String = Process.arguments[1]
let cmd = Array(Process.arguments[2..<Process.arguments.count])
let dir = cwd()

let statuses = Chan<Int32>()
let events = FSEvents(paths: [path])

go {
    for status in statuses {
        if status != 0 {
            print(" failed : \(cmd.joined(separator: " "))")
        }
    }
}

for event in events {
    let paths = event.paths
        .map { $0.removePrefix("\(dir)/") }
        .joined(separator: ", ")

    print("changed : \(paths)")
    go { statuses <- exec(cmd) }
}
