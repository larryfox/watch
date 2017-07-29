import Foundation

signal(SIGINT) { exit($0) }

let ARGV = CommandLine.arguments

var singleline = true
var offset = 1

if ARGV.count > offset && ARGV[1] == "-n" {
    singleline = false
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
    let paths = events.map { $0.path.removePrefix("\(dir)/") }

    if singleline {
        println("\(paths.joined(separator: ":"))")
    } else {
        paths.forEach { println($0) }
    }

    if hasCmd {
        async { _ = exec(cmd) }
    }
}
