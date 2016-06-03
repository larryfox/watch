## watch

Watch a directory, file, or files for changes and run a command.

### Usage

~~~ bash
$ watch [-n] <path> [<cmd>...]
~~~

When multiple changes happen quickly changes are buffered and grouped into one event.

- `cmd` is ran once per event
- `-n` splits the filenames of an event onto new lines. By default they are seperated by a colon.

### Examples

~~~ bash
$ watch Source/ make
$ watch js/ npm run build
$ watch -n js/ | xargs -I '%' cat %
~~~

### Installing

~~~ bash
$ make install
~~~

*Compiling with [Swift version `3.0-dev` (May 31, 2016)](https://swift.org/download/#snapshots)*

### Why

Most watch utilites either poll on an interval or require complicated configuration.
This uses [FSEvents](https://en.wikipedia.org/wiki/FSEvents) and has a simple api.
