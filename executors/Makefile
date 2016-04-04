all: main

main: main.nim executor.nim sequential.nim parallel.nim print.nim
	nim compile main.nim
run: main
	./main

clean:
	rm -fr main nimcache
