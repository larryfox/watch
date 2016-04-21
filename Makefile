PREFIX ?= /usr/local

all: build

build: $(wildcard Sources/*.swift)
	swift build

clean:
	swift build --clean

install: build
	 install .build/debug/watch $(PREFIX)/bin/watch

uninstall:
	rm -f $(PREFIX)/bin/watch

.PHONY: all clean install uninstall