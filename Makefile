.PHONY: test
compile:
	coffee -j index.js -cb src/
watch:
	coffee -j index.js -cbw src/
test:
	mocha
