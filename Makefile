
all: js install

js: clean
	coffee -bc lib/genetics.coffee
	coffee -bc lib/sol.coffee

clean:
	rm -rvf ~/.npm/genetics ~/node_modules/genetics
	rm -rvf lib/genetics.js
	rm -rvf lib/sol.js

install:
	cd .. && npm install ./genetics

