GO ?= go
GOPATH ?= $(HOME)/go
GO_VERSION = 1.18

#$(GO) install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.44.2
$(GOPATH)/bin/hugo:
	$(GO) install github.com/gohugoio/hugo@v0.95.0

HOMEBREW_PREFIX ?= /usr/local
HOMEBREW_BIN = $(HOMEBREW_PREFIX)/bin

#npm install postcss-cli

deps: $(GOPATH)/bin/hugo

setup: deps

serve:
	open "http://localhost:1313"
	hugo serve --disableFastRender --buildDrafts

deploy:
	./deploy.sh

build:
	@hugo --minify

NOW=$(shell date +%Y%m%d%H%M%S)
new-post:
	@hugo new posts/$(NOW)-$(title).md

test:
	@echo $(CURRENT_POST_FOLDER)