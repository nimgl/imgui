all: Makefile
	nim cpp -d:strip test.nim

clean:
	@-rm -fr .nimcache
	@-rm test

run: all
	./test
