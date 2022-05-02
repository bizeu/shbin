.PHONY: clean head main tests

SHELL := $(shell command -v bash)
DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export BASH_ENV := $(DIR).envrc
basename := $(shell basename $(DIR))


clean:
	@true

head: tests
	@git add -A && git commit --quiet -a -m "auto" && git push --quiet && \
	brew reinstall --quiet bizeu/tap/shbin $(basename) && \
	brew postinstall --quiet $(basename)  # brew upgrade can not be done when --HEAD installed

main: tests
	@git add -A && git commit --quiet -a -m "auto" && git push --quiet && brew upgrade --quiet $(basename)

tests: clean
	@true
