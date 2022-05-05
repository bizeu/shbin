.PHONY: build clean head main publish tests

SHELL := $(shell command -v bash)
DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export BASH_ENV := /etc/profile
basename := $(shell basename $(DIR))
tmp := $(shell mktemp -d)

build: clean
	@mkdir -p ./build && python3 -m build --wheel -o $(tmp) $(DIR)

clean:
	@rm -rf build dist

head: tests
	@git add -A && git commit --quiet -a -m "auto" && git push --quiet && \
	brew reinstall --quiet $(basename) && \
	brew postinstall --quiet $(basename)  # brew upgrade can not be done when --HEAD installed

main: tests
	@git add -A && git commit --quiet -a -m "auto" && git push --quiet && brew reinstall --quiet $(basename)


publish: build clean
	@git tag $(next)
	@git push --quiet
	@git push --quiet --tags
	@python3 -m build --wheel -o $(tmp) $(DIR)
	@twine upload $(tmp)/*

tests: clean
	@true
