
all: clean install

clean:
	rm -rvf ~/.npm/genetics ~/node_modules/genetics

install:
	cd .. && npm install ./genetics

