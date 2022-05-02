.PHONY: bats publish test tests version

SHELL := $(shell bash -c 'command -v bash')
msg := feat: first
export msg

bats:
	@! brew list bats &>/dev/null || brew uninstall bats
	@brew bundle --file tests/Brewfile --quiet --no-lock | grep -v "^Using"

publish: tests
	@git add .
	@git commit --quiet -a -m "$${msg:-auto}" || true
	@git push --quiet

tests: bats
	@bin/shts
