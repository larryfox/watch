import Foundation

guard Process.arguments.count >= 3 else {
    print("usage: watch <path> <cmd>...")
    exit(1)
}

signal(SIGINT) { exit($0) }

let path = Process.arguments[1]
let cmd = Array(Process.arguments[2..<Process.arguments.count])
let dir = cwd()
let statuses = Chan<Int32>()
let stream = FSEventStream(paths: [path])

go {
    for status in statuses {
        if status != 0 {
            print(" failed : [\(status)] \(cmd.joined(separator: " "))")
        }
    }
}

for events in stream {
    let paths = events
        .map { $0.path.removePrefix("\(dir)/") }
        .joined(separator: ", ")

    print("changed : \(paths)")
    go { statuses <- exec(cmd) }
}
