build:
	hyc src/tfs.hy
	hyc src/config.hy
	hyc src/list.hy
	hyc src/client.hy
	mv src/*.pyc ./bin

pip:
	pip install validators
	pip install termcolor
	pip install requests
	pip install tabulate
	pip install inquirer
