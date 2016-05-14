import Foundation

signal(SIGINT) { exit($0) }

let ARGV = Process.arguments

var separator = ":"
var offset = 1

if ARGV.count > offset && ARGV[1] == "-n" {
    separator = "\n"
    offset = 2
}

guard ARGV.count > offset else {
    fputs("usage: watch [-n] <path> [<command>]", stderr)
    exit(1)
}

let path = ARGV[offset]
let cmd = Array(ARGV[(1 + offset)..<ARGV.count])
let hasCmd = !cmd.isEmpty
let dir = cwd()
let stream = FSEventStream(paths: [path])

for events in stream {
    let paths = events
        .map { $0.path.removePrefix("\(dir)/") }
        .joined(separator: separator)

    fputs("\(paths)\n", stdout)
    fflush(stdout)

    if hasCmd {
        go { exec(cmd) }
    }
}
