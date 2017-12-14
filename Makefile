build:
	hyc src/tfs.hy
	hyc src/config.hy
	hyc src/board.hy
	hyc src/messages.hy
	mv src/*.pyc ./bin

pip:
	pip install validators
	pip install termcolor
	pip install requests
